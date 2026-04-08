// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "UITextView-WZB",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "WZBTextView",
            targets: ["WZBTextView"]
        )
    ],
    targets: [
        .target(
            name: "WZBTextView",
            path: "Sources/WZBTextView"
        )
    ]
)
