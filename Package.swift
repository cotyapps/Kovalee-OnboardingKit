// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KovaleeOnboardingKit",
	platforms: [
			.iOS(.v16)
	],
	products: [
		.library(
			name: "KovaleeOnboardingKit",
			targets: [
				"OnboardingKit",
				"OnboardingKitExtras"
			]
		)
	],
	dependencies: [
		.package(url: "https://github.com/cotyapps/Kovalee-iOS-SDK", from: Version(1, 9, 12)),
	],
	targets: [
		.binaryTarget(
			name: "OnboardingKit",
			path: "./Frameworks/OnboardingKit.xcframework"
		),
		.target(
			name: "OnboardingKitExtras",
			dependencies: [
				"OnboardingKit",
				.product(name: "KovaleeSDK", package: "Kovalee-iOS-SDK")
			]
		)
	]
)
