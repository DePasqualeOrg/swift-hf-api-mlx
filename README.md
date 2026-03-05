# Swift HF API MLX

This package allows [Swift HF API](https://github.com/DePasqualeOrg/swift-hf-api) to seamlessly integrate with [MLX Swift LM](https://github.com/ml-explore/mlx-swift-lm) by providing protocol conformance and convenience overloads.

Refer to the [Benchmarks](#Benchmarks) section to compare the performance of Swift HF API and Swift Hugging Face.

It provides two modules:

- `MLXLMHFAPI` for LLM and VLM loading
- `MLXEmbeddersHFAPI` for embedding model loading

## Setup

Add this package alongside MLX Swift LM in your `Package.swift`:

```swift
.package(url: "https://github.com/DePasqualeOrg/swift-hf-api-mlx/", from: "0.1.0"),
```

And add the modules you need to your target's dependencies:

```swift
.product(name: "MLXLMHFAPI", package: "swift-hf-api-mlx"),
// and/or
.product(name: "MLXEmbeddersHFAPI", package: "swift-hf-api-mlx"),
```

## Usage

`MLXLMHFAPI` provides convenience overloads with `HubClient.default` as the default downloader, so you can omit the `from:` parameter:

```swift
import MLXLLM
import MLXLMHFAPI
import MLXLMTokenizers

// HubClient.default is used automatically
let model = try await loadModel(
    using: TokenizersLoader(),
    id: "mlx-community/Qwen3-4B-4bit"
)
```

With a custom Hub client:

```swift
import MLXLLM
import MLXLMHFAPI
import MLXLMTokenizers

let hub = HubClient(token: "hf_...")
let container = try await loadModelContainer(
    from: hub,
    using: TokenizersLoader(),
    id: "mlx-community/Qwen3-4B-4bit"
)
```

You can also pass `HubClient.default` explicitly to the core API:

```swift
let container = try await loadModelContainer(
    from: HubClient.default,
    using: TokenizersLoader(),
    id: "mlx-community/Qwen3-4B-4bit"
)
```

## Re-exports

Both modules re-export `HFAPI`, so you get access to `HubClient` and other types without an additional import.

## Testing

Benchmarks for download cache hit performance and model loading are included.

## Benchmarks

The benchmarks use tests from MLX Swift LM and can be run from this package in Xcode.

These results were observed on an M3 MacBook Pro.

| Benchmark | Swift HF API median | Swift Hugging Face median | Swift HF API Performance |
| --- | ---: | ---: | --- |
| Download cache hit | 0.6 ms | 144.0 ms | 240.00x faster |
| LLM load | 77.9 ms | 317.0 ms | 4.07x faster |
| VLM load | 198.9 ms | 408.2 ms | 2.05x faster |
| Embedding load | 90.5 ms | 262.8 ms | 2.90x faster |
