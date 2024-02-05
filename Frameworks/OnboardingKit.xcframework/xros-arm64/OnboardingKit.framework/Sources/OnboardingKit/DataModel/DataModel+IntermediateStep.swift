import Foundation

// MARK: Intermediate Step
@dynamicMemberLookup
struct IntermediateStep {
	var configuration: StepBasicConfiguration
	var image: String?
	var mediaPosition: MediaPosition
	var imageSize: ImageSize

	subscript<T>(dynamicMember keyPath: KeyPath<StepBasicConfiguration, T>) -> T {
		configuration[keyPath: keyPath]
	}
}

extension IntermediateStep: StepTypeConfiguration {
	static func createFromJSONStep(_ jsonStep: JSONStep) -> IntermediateStep {
		Self(
			configuration: StepBasicConfiguration.defaultMapping(fromJSON: jsonStep),
			image: jsonStep.image,
			mediaPosition: jsonStep.imagePosition ?? .belowTitle,
			imageSize: jsonStep.imageSize ?? .large
		)
	}
}

extension IntermediateStep {
	static let mock = Self(
		configuration: StepBasicConfiguration(
			title: "this is an intermediate step",
			description: String.mockDescription,
			information: String.mockInformation,
			progressBarEnabled: true,
			progressBarTitle: "",
			skipEnabled: false,
			backEnabled: true
		),
		image: nil,
		mediaPosition: .belowTitle,
		imageSize: .large
	)

	static let mockImageAboveTile = Self(
		configuration: StepBasicConfiguration(
			title: "this is an intermediate step",
			description: String.mockDescription,
			information: String.mockInformation
		),
		image: nil,
		mediaPosition: .aboveTitle,
		imageSize: .small
	)
	
	static let mockImageAboveDescription = Self(
		configuration: StepBasicConfiguration(
			title: "this is an intermediate step",
			description: String.mockDescription,
			information: String.mockInformation
		),
		image: nil,
		mediaPosition: .belowDescription,
		imageSize: .small
	)
}

extension String {
	static let mockDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam a aliquam magna."
	static let mockInformation = "Maecenas sodales tempus ex, a vulputate mi commodo at. Ut libero urna, dictum sit amet congue posuere, pulvinar at sapien."
}
