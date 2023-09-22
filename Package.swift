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
				"KovaleeOnboardingKit",
			]
		)
	],
	dependencies: [],
	targets: [
		.binaryTarget(
			name: "OnboadingKit",
			path: "./Frameworks/OnboardingKit.xcframework"
		),
		
		.target(
			name: "KovaleeOnboardingKit",
			dependencies: [
				"OnboadingKit"
			]
		)
	]
)
