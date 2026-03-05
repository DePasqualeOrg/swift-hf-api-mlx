import BenchmarkHelpers
import MLXLMHFAPI
import Testing

@Suite(.serialized)
struct Benchmarks {

    @Test func downloadCacheHit() async throws {
        let stats = try await benchmarkDownloadCacheHit(
            from: HubClient.default
        )
        stats.printSummary(label: "Download cache hit (swift-hf-api)")
    }

    @Test func loadLLM() async throws {
        let stats = try await benchmarkLLMLoading(
            from: HubClient.default,
            using: NoOpTokenizerLoader()
        )
        stats.printSummary(label: "LLM load (swift-hf-api, no-op tokenizer)")
    }

    @Test func loadVLM() async throws {
        let stats = try await benchmarkVLMLoading(
            from: HubClient.default,
            using: NoOpTokenizerLoader()
        )
        stats.printSummary(label: "VLM load (swift-hf-api, no-op tokenizer)")
    }

    @Test func loadEmbedding() async throws {
        let stats = try await benchmarkEmbeddingLoading(
            from: HubClient.default,
            using: NoOpTokenizerLoader()
        )
        stats.printSummary(label: "Embedding load (swift-hf-api, no-op tokenizer)")
    }
}
