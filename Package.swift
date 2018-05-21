// swift-tools-version:4.1
//
//  Package.swift
//  ostkit
//
//  Created by Duong Khong on 5/21/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "ostkit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ostkit",
            targets: ["ostkit"]),
        ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .exact("0.9.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ostkit",
            dependencies: ["Alamofire", "CryptoSwift"]
        ),
        .testTarget(
            name: "ostkitTests",
            dependencies: ["ostkit"],
            path: "ostkitTests"),
        ]
)
