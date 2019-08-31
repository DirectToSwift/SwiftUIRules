// swift-tools-version:5.1

import PackageDescription

let package = Package(
  
  name: "SwiftUIRules",
  
  platforms: [
    .macOS(.v10_15), .iOS(.v13), .watchOS(.v6)
  ],
  
  products: [
    .library(name: "SwiftUIRules", targets: [ "SwiftUIRules" ])
  ],
  
  dependencies: [],
  
  targets: [
    .target(name: "SwiftUIRules", dependencies: [])
  ]
)
