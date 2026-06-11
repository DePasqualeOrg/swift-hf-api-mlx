// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "swift-hf-api-mlx",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "MLXLMHFAPI", targets: ["MLXLMHFAPI"]),
        .library(name: "MLXEmbeddersHFAPI", targets: ["MLXEmbeddersHFAPI"]),
    ],
    dependencies: [
        // TODO: Pin to a tagged release once the fork publishes one. A branch dependency
        // blocks versioned consumers, so no new version tags of this package until then.
        .package(url: "https://github.com/DePasqualeOrg/mlx-swift-lm.git", branch: "main"),
        // 0.4.1 is the floor: its artifactbundle localizes non-FFI Rust globals, fixing
        // duplicate-symbol link failures alongside other Rust-backed packages.
        .package(url: "https://github.com/DePasqualeOrg/swift-hf-api.git", .upToNextMinor(from: "0.4.1")),
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
                "MLXEmbeddersHFAPI",
                .product(name: "MLXEmbedders", package: "mlx-swift-lm"),
                .product(name: "BenchmarkHelpers", package: "mlx-swift-lm"),
            ]
        ),
    ]
)
