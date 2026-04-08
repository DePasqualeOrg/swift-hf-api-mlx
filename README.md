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

| | Swift Hugging Face | Swift HF API | |
| --- | ---: | ---: | --- |
| Download cache hit | 150.3 ms | 0.6 ms | 250.5x faster |
| LLM load | 203.6 ms | 48.5 ms | 4.2x faster |
| VLM load | 300.9 ms | 145.1 ms | 2.1x faster |
| Embedding load | 221.9 ms | 65.9 ms | 3.4x faster |

These results were observed on an M3 MacBook Pro using Swift HF API [`0.2.2`](https://github.com/DePasqualeOrg/swift-hf-api/releases/tag/0.2.2), Swift Hugging Face [`0.9.0`](https://github.com/huggingface/swift-huggingface/releases/tag/0.9.0), and MLX Swift LM `8c9dd63`.

### Running benchmarks

The benchmarks use tests from MLX Swift LM and can be run from this package in Xcode or from the command line with `xcodebuild`:

```bash
xcodebuild test -scheme swift-hf-api-mlx-Package -configuration Release -destination 'platform=macOS,arch=arm64' -only-testing:Benchmarks
```
