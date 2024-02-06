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
				"ONBKitDevMode",
				"OnboadingKit",
				"_OnboardingKitStub"
			]
		)
	],
	dependencies: [
		.package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: Version(10, 12, 0)),
		.package(url: "https://github.com/twostraws/CodeScanner", from: Version(2, 3, 3))
	],
	targets: [
		.target(
			name: "ONBKitDevMode",
			dependencies: [
				"OnboadingKit",
				.product(name: "CodeScanner", package: "CodeScanner"),
				.product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
			]
		),
		.binaryTarget(
			name: "OnboadingKit",
			path: "./Frameworks/OnboardingKit.xcframework"
		),
		.target(name: "_OnboardingKitStub")
	]
)
