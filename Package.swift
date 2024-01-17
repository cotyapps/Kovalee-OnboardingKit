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
				"Lottie",
				"_LottieStub",
				"_OnboardingKitStub"
			]
		)
	],
	dependencies: [
		.package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: Version(10, 12, 0)),
	],
	targets: [
		.target(
			name: "ONBKitDevMode",
			dependencies: [
				"OnboadingKit",
				.product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
			]
		),
		.binaryTarget(
			name: "OnboadingKit",
			path: "./Frameworks/OnboardingKit.xcframework"
		),
		.binaryTarget(
			name: "Lottie",
			path: "./Frameworks/Lottie.xcframework"
		),
		.target(name: "_LottieStub"),
		.target(name: "_OnboardingKitStub")
	]
)
