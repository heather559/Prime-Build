// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PrimeBuildMac",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "PrimeBuildMac", targets: ["PrimeBuildMac"])
    ],
    targets: [
        .executableTarget(
            name: "PrimeBuildMac",
            path: "Sources/PrimeBuildMac"
        )
    ]
)
