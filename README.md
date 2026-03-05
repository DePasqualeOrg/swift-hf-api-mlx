# Swift HF API MLX

This package allows [Swift HF API](https://github.com/DePasqualeOrg/swift-hf-api) to seamlessly integrate with [MLX Swift LM](https://github.com/ml-explore/mlx-swift-lm) by providing protocol conformance and convenience overloads.

It provides two modules:

- `MLXLMHFAPI` for LLM and VLM loading
- `MLXEmbeddersHFAPI` for embedding model loading

## Setup

Add this package alongside mlx-swift-lm in your `Package.swift`:

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
