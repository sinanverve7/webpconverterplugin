// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Webpconverterplugin",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Webpconverterplugin",
            targets: ["WebpconverterPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "WebpconverterPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/WebpconverterPlugin"),
        .testTarget(
            name: "WebpconverterPluginTests",
            dependencies: ["WebpconverterPlugin"],
            path: "ios/Tests/WebpconverterPluginTests")
    ]
)