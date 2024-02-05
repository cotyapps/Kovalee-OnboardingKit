import Foundation

// MARK: Input Step
@dynamicMemberLookup
struct InputStep {
	var configuration: StepBasicConfiguration
	var placeholder: String
	var mode: InputMode

	enum InputMode: String, Decodable {
		case text
		case email
		case phone
		case number
	}
	
	subscript<T>(dynamicMember keyPath: KeyPath<StepBasicConfiguration, T>) -> T {
		configuration[keyPath: keyPath]
	}
}

extension InputStep: StepTypeConfiguration {
	static func createFromJSONStep(_ jsonStep: JSONStep) -> Self {
		Self(
			configuration: StepBasicConfiguration.defaultMapping(fromJSON: jsonStep),
			placeholder: jsonStep.placeholder ?? "",
			mode: jsonStep.inputMode ?? .text
		)
	}
}

extension InputStep {
	static let mock = Self(
		configuration: StepBasicConfiguration(
			property: "name",
			title: "How can we call you?",
			continueButtonTitle: "Continue",
			progressBarEnabled: true,
			progressBarTitle: "",
			skipEnabled: false,
			backEnabled: true
		),
		placeholder: "Your name",
		mode: .email
	)
}
