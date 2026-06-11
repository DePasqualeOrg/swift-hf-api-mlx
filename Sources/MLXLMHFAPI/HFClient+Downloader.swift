// Copyright © Anthony DePasquale

import Foundation
import HFAPI
import MLXLMCommon

public enum HuggingFaceDownloaderError: LocalizedError {
    case invalidRepositoryID(String)

    public var errorDescription: String? {
        switch self {
        case .invalidRepositoryID(let id):
            return "Invalid Hugging Face repository ID: '\(id)'. Expected format 'namespace/name'."
        }
    }
}

extension HFClient {
    /// Shared zero-config client: environment token resolution and the
    /// platform-default cache directory. Matches the ergonomics of 0.3.x's
    /// `HubClient.default`.
    ///
    /// `HFClient.init` throws only on developer or environment
    /// misconfiguration (a malformed `HF_ENDPOINT`, an empty static token),
    /// so a trap here surfaces the configuration error at first use rather
    /// than forcing every call site through a throwing accessor.
    public static let `default`: HFClient = {
        do {
            return try HFClient()
        } catch {
            fatalError("Failed to create default HFClient: \(error.localizedDescription)")
        }
    }()
}

/// Accumulates `DownloadEvent`s behind a lock so the `@Sendable` progress
/// closure can fold events into one `DownloadProgressState`.
///
/// `@unchecked Sendable` is sound because every access to `state` goes
/// through `lock`.
private final class DownloadProgressAccumulator: @unchecked Sendable {
    private let lock = NSLock()
    private var state = DownloadProgressState()

    /// Fold one event and return the updated display fraction and byte
    /// total, or `nil` while totals are still unknown.
    func observe(_ event: DownloadEvent) -> (fraction: Double, totalBytes: UInt64)? {
        lock.withLock {
            state.observe(event)
            guard let fraction = state.fractionCompleted else { return nil }
            return (fraction, state.totalBytes)
        }
    }
}

/// Whether a cached snapshot plausibly contains the weights the caller asked
/// for. A cached snapshot can be a partial download from an earlier, narrower
/// pattern set (for example a tokenizer-only `*.json` fetch), and the cache
/// cannot distinguish "file not in the repo" from "file not downloaded". Two
/// checks cover the model-loading cases: every safetensors-shaped pattern
/// must match at least one cached file, and when a safetensors index is
/// cached, every weight file it lists must be present. Repos that genuinely
/// contain no safetensors fail the first check and pay one revalidating
/// network round-trip instead.
private func cachedSnapshotSatisfies(patterns: [String], at directory: URL) -> Bool {
    guard
        let files = try? FileManager.default.subpathsOfDirectory(atPath: directory.path)
    else {
        return false
    }

    for pattern in patterns where pattern.contains("safetensors") {
        let matched = files.contains { path in
            fnmatch(pattern, path, 0) == 0
                || fnmatch(pattern, (path as NSString).lastPathComponent, 0) == 0
        }
        if !matched {
            return false
        }
    }

    let indexURL = directory.appending(path: "model.safetensors.index.json")
    if let data = try? Data(contentsOf: indexURL),
        let index = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let weightMap = index["weight_map"] as? [String: String]
    {
        let present = Set(files)
        for weightFile in Set(weightMap.values) where !present.contains(weightFile) {
            return false
        }
    }

    return true
}

extension HFClient: @retroactive Downloader {

    public func download(
        id: String,
        revision: String?,
        matching patterns: [String],
        useLatest: Bool,
        progressHandler: @Sendable @escaping (Progress) -> Void
    ) async throws -> URL {
        guard let repoID = RepositoryID(id) else {
            throw HuggingFaceDownloaderError.invalidRepositoryID(id)
        }
        let repository = model(repoID)

        // The Downloader contract treats an empty pattern list as "the whole
        // repository", whereas hf-hub treats an empty allow list as "nothing".
        let allowPatterns = patterns.isEmpty ? nil : patterns

        if !useLatest,
            let cached = try await repository.resolveCachedSnapshot(
                revision: revision,
                allowPatterns: allowPatterns
            ),
            cachedSnapshotSatisfies(patterns: patterns, at: cached)
        {
            return cached
        }

        let accumulator = DownloadProgressAccumulator()
        return try await repository.snapshotDownload(
            revision: revision,
            allowPatterns: allowPatterns,
            progress: { event in
                guard let (fraction, totalBytes) = accumulator.observe(event) else { return }
                let total = totalBytes > 0 ? Int64(totalBytes) : 1
                let progress = Progress(totalUnitCount: total)
                progress.completedUnitCount = Int64((fraction * Double(total)).rounded())
                progressHandler(progress)
            }
        )
    }
}
