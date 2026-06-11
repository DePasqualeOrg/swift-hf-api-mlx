import BenchmarkHelpers
import MLXEmbedders
import MLXEmbeddersHFAPI
import MLXLMHFAPI
import Testing

@Suite(.serialized)
struct Benchmarks {

    @Test func downloadCacheHit() async throws {
        let stats = try await benchmarkDownloadCacheHit(
            from: HFClient.default
        )
        stats.printSummary(label: "Download cache hit (swift-hf-api)")
    }

    @Test func loadLLM() async throws {
        let stats = try await benchmarkLLMLoading(
            from: HFClient.default,
            using: NoOpTokenizerLoader()
        )
        stats.printSummary(label: "LLM load (swift-hf-api, no-op tokenizer)")
    }

    @Test func loadVLM() async throws {
        let stats = try await benchmarkVLMLoading(
            from: HFClient.default,
            using: NoOpTokenizerLoader()
        )
        stats.printSummary(label: "VLM load (swift-hf-api, no-op tokenizer)")
    }

    @Test func loadEmbedding() async throws {
        let stats = try await benchmarkEmbeddingLoading(
            from: HFClient.default,
            using: NoOpTokenizerLoader()
        )
        stats.printSummary(label: "Embedding load (swift-hf-api, no-op tokenizer)")
    }

    @Test func embeddingConvenience() async throws {
        let config = EmbedderRegistry.minilm_l6_4bit
        let loader = NoOpTokenizerLoader()

        // Free function loadModelContainer (default HFClient)
        _ = try await MLXEmbeddersHFAPI.loadModelContainer(
            using: loader,
            configuration: config
        )

        // Free function loadModel (default HFClient)
        _ = try await MLXEmbeddersHFAPI.loadModel(
            using: loader,
            configuration: config
        )

        // EmbedderModelFactory extension loadContainer (explicit HFClient)
        _ = try await EmbedderModelFactory.shared.loadContainer(
            from: HFClient.default,
            using: loader,
            configuration: config
        )

        // EmbedderModelFactory extension load (explicit HFClient)
        _ = try await EmbedderModelFactory.shared.load(
            from: HFClient.default,
            using: loader,
            configuration: config
        )
    }
}
