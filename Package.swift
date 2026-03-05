// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "swift-hf-api-mlx",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "MLXLMHFAPI", targets: ["MLXLMHFAPI"]),
        .library(name: "MLXEmbeddersHFAPI", targets: ["MLXEmbeddersHFAPI"]),
    ],
    dependencies: [
        // TODO: Change to ml-explore/mlx-swift-lm before PR #118 is merged
        .package(url: "https://github.com/DePasqualeOrg/mlx-swift-lm.git", branch: "swift-tokenizers"),
        .package(url: "https://github.com/DePasqualeOrg/swift-hf-api", from: "0.2.2"),
    ],
    targets: [
        .target(
            name: "MLXLMHFAPI",
            dependencies: [
                .product(name: "MLXLMCommon", package: "mlx-swift-lm"),
                .product(name: "HFAPI", package: "swift-hf-api"),
            ]
        ),
        .target(
            name: "MLXEmbeddersHFAPI",
            dependencies: [
                .product(name: "MLXEmbedders", package: "mlx-swift-lm"),
                "MLXLMHFAPI",
                .product(name: "HFAPI", package: "swift-hf-api"),
            ]
        ),
        .testTarget(
            name: "Benchmarks",
            dependencies: [
                "MLXLMHFAPI",
                .product(name: "BenchmarkHelpers", package: "mlx-swift-lm"),
            ]
        ),
    ]
)
