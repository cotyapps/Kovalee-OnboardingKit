import Foundation

// MARK: Loading Step
@dynamicMemberLookup
struct CustomStep: Decodable {
	var configuration: StepBasicConfiguration
	var name: String
	var type: CustomStepType

	subscript<T>(dynamicMember keyPath: KeyPath<StepBasicConfiguration, T>) -> T {
		configuration[keyPath: keyPath]
	}
}

enum CustomStepType: String, Decodable {
	case fullScreen
	case contentOnly
}

extension CustomStep: StepTypeConfiguration {
	static func createFromJSONStep(_ jsonStep: JSONStep) -> CustomStep {
		var basicConfig = StepBasicConfiguration.defaultMapping(fromJSON: jsonStep)
		if case .fullScreen = jsonStep.customStepType {
			basicConfig.progressBarEnabled = false
		}
		return Self(
			configuration: basicConfig,
			name: jsonStep.customName ?? "",
			type: jsonStep.customStepType ?? .contentOnly
		)
	}
}
