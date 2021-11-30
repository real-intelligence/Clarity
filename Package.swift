// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Clarity",
    platforms: [.macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7)],
    products: [.library(
        name: "Clarity",
        targets: ["Clarity"]
    )
    ],
    
    targets: [
        .target(
            name: "Clarity",
            path: "Sources",
            exclude: [
                "Clarity/Info.plist",
                "Clarity_tv/Info.plist",
                "Clarity_iOS/Info.plist",
                "Clarity_watch/Info.plist"
                
            ]
            
        ),
        .testTarget(
            name: "ClarityTests",
            dependencies: ["Clarity"],
            path: "Tests",
            exclude: [
                "ClarityTests/Info.plist"
            ]
        )],
    swiftLanguageVersions: [.v5]
)
