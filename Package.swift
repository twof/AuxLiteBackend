// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SpotifyService",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "3.0.0")),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", .upToNextMajor(from: "3.0.0")),
        
        .package(url: "https://github.com/vapor/auth.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/crypto.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/twof/VaporCRUDRouter.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor", "CrudRouter"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

