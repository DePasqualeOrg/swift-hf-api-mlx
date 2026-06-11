// Copyright © Anthony DePasquale

import Foundation
import HFAPI
import MLXEmbedders
import MLXLMCommon
import MLXLMHFAPI

// MARK: - EmbedderModelFactory convenience overloads

extension EmbedderModelFactory {

    /// Load an embedding model using the default Hugging Face Hub client.
    public func load(
        from hub: HFClient = .default,
        using tokenizerLoader: any TokenizerLoader,
        configuration: ModelConfiguration,
        useLatest: Bool = false,
        progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
    ) async throws -> sending EmbedderModelContext {
        try await load(
            from: hub as any Downloader,
            using: tokenizerLoader,
            configuration: configuration,
            useLatest: useLatest,
            progressHandler: progressHandler
        )
    }

    /// Load an embedding model container using the default Hugging Face Hub client.
    public func loadContainer(
        from hub: HFClient = .default,
        using tokenizerLoader: any TokenizerLoader,
        configuration: ModelConfiguration,
        useLatest: Bool = false,
        progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
    ) async throws -> EmbedderModelContainer {
        try await loadContainer(
            from: hub as any Downloader,
            using: tokenizerLoader,
            configuration: configuration,
            useLatest: useLatest,
            progressHandler: progressHandler
        )
    }
}

// MARK: - Free function convenience overloads

/// Load an embedding model using the default Hugging Face Hub client.
public func loadModel(
    from hub: HFClient = .default,
    using tokenizerLoader: any TokenizerLoader,
    configuration: ModelConfiguration,
    useLatest: Bool = false,
    progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
) async throws -> sending EmbedderModelContext {
    try await EmbedderModelFactory.shared.load(
        from: hub,
        using: tokenizerLoader,
        configuration: configuration,
        useLatest: useLatest,
        progressHandler: progressHandler
    )
}

/// Load an embedding model container using the default Hugging Face Hub client.
public func loadModelContainer(
    from hub: HFClient = .default,
    using tokenizerLoader: any TokenizerLoader,
    configuration: ModelConfiguration,
    useLatest: Bool = false,
    progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
) async throws -> EmbedderModelContainer {
    try await EmbedderModelFactory.shared.loadContainer(
        from: hub,
        using: tokenizerLoader,
        configuration: configuration,
        useLatest: useLatest,
        progressHandler: progressHandler
    )
}
