// Copyright © Anthony DePasquale

import Foundation
import HFAPI
import MLXLMCommon

// MARK: - ModelFactory convenience overloads

extension ModelFactory {

    /// Load a model using the default Hugging Face Hub client.
    public func load(
        from hub: HubClient = .default,
        using tokenizerLoader: any TokenizerLoader,
        configuration: MLXLMCommon.ModelConfiguration,
        useLatest: Bool = false,
        progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
    ) async throws -> sending ModelContext {
        try await load(
            from: hub as any Downloader,
            using: tokenizerLoader,
            configuration: configuration,
            useLatest: useLatest,
            progressHandler: progressHandler
        )
    }

    /// Load a model container using the default Hugging Face Hub client.
    public func loadContainer(
        from hub: HubClient = .default,
        using tokenizerLoader: any TokenizerLoader,
        configuration: MLXLMCommon.ModelConfiguration,
        useLatest: Bool = false,
        progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
    ) async throws -> ModelContainer {
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

/// Load a model using the default Hugging Face Hub client.
public func loadModel(
    from hub: HubClient = .default,
    using tokenizerLoader: any TokenizerLoader,
    configuration: MLXLMCommon.ModelConfiguration,
    useLatest: Bool = false,
    progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
) async throws -> sending ModelContext {
    try await MLXLMCommon.loadModel(
        from: hub,
        using: tokenizerLoader,
        configuration: configuration,
        useLatest: useLatest,
        progressHandler: progressHandler
    )
}

/// Load a model container using the default Hugging Face Hub client.
public func loadModelContainer(
    from hub: HubClient = .default,
    using tokenizerLoader: any TokenizerLoader,
    configuration: MLXLMCommon.ModelConfiguration,
    useLatest: Bool = false,
    progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
) async throws -> sending ModelContainer {
    try await MLXLMCommon.loadModelContainer(
        from: hub,
        using: tokenizerLoader,
        configuration: configuration,
        useLatest: useLatest,
        progressHandler: progressHandler
    )
}

/// Load a model by ID using the default Hugging Face Hub client.
public func loadModel(
    from hub: HubClient = .default,
    using tokenizerLoader: any TokenizerLoader,
    id: String,
    revision: String = "main",
    useLatest: Bool = false,
    progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
) async throws -> sending ModelContext {
    try await MLXLMCommon.loadModel(
        from: hub,
        using: tokenizerLoader,
        id: id,
        revision: revision,
        useLatest: useLatest,
        progressHandler: progressHandler
    )
}

/// Load a model container by ID using the default Hugging Face Hub client.
public func loadModelContainer(
    from hub: HubClient = .default,
    using tokenizerLoader: any TokenizerLoader,
    id: String,
    revision: String = "main",
    useLatest: Bool = false,
    progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
) async throws -> sending ModelContainer {
    try await MLXLMCommon.loadModelContainer(
        from: hub,
        using: tokenizerLoader,
        id: id,
        revision: revision,
        useLatest: useLatest,
        progressHandler: progressHandler
    )
}

// MARK: - ModelAdapterFactory convenience overload

extension ModelAdapterFactory {

    /// Load an adapter using the default Hugging Face Hub client.
    public func load(
        from hub: HubClient = .default,
        configuration: MLXLMCommon.ModelConfiguration,
        useLatest: Bool = false,
        progressHandler: @Sendable @escaping (Progress) -> Void = { _ in }
    ) async throws -> ModelAdapter {
        try await load(
            from: hub as any Downloader,
            configuration: configuration,
            useLatest: useLatest,
            progressHandler: progressHandler
        )
    }
}
