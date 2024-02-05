import Foundation

// MARK: Loading Step
@dynamicMemberLookup
struct LoadingStep: Decodable {
	var configuration: StepBasicConfiguration

	var loadingSteps: [String]
	var loadingTitle: String
	var completedTitle: String
	var completedDescription: String

	subscript<T>(dynamicMember keyPath: KeyPath<StepBasicConfiguration, T>) -> T {
		configuration[keyPath: keyPath]
	}
}

extension LoadingStep: StepTypeConfiguration {
	static func == (lhs: LoadingStep, rhs: LoadingStep) -> Bool {
		lhs.title == rhs.title
	}
	
	static func createFromJSONStep(_ jsonStep: JSONStep) -> LoadingStep {
		Self(
			configuration: StepBasicConfiguration.defaultMapping(fromJSON: jsonStep),
			loadingSteps: jsonStep.loadingSteps?.flatMap {
				$0.filter { step in step.key == "title" }.map { step in step.value }
			} ?? [String](),
			loadingTitle: jsonStep.loadingTitle ?? "",
			completedTitle: jsonStep.completedTitle ?? "",
			completedDescription: jsonStep.completedDescription ?? ""
		)
	}
}

extension LoadingStep {
	static let mock = Self(
		configuration: StepBasicConfiguration(),
		loadingSteps: [
			"First Step",
			"Second Step",
			"Third Step",
			"Forth Step"
		],
		loadingTitle: "This is a loading Screen",
		completedTitle: "Loading Complete",
		completedDescription: "This Step has completed loading"
	)
}
