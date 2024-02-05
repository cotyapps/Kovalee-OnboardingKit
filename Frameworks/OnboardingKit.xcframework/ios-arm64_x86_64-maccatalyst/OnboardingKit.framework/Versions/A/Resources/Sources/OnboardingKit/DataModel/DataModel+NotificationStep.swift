import Foundation

// MARK: Notifications Step
@dynamicMemberLookup
struct NotificationsStep {
	var configuration: StepBasicConfiguration

	var image: String?
	
	subscript<T>(dynamicMember keyPath: KeyPath<StepBasicConfiguration, T>) -> T {
		configuration[keyPath: keyPath]
	}
}

extension NotificationsStep: StepTypeConfiguration {
	static func createFromJSONStep(_ jsonStep: JSONStep) -> NotificationsStep {
		var step = Self(
			configuration: StepBasicConfiguration.defaultMapping(fromJSON: jsonStep),
			image: jsonStep.image
		)
		
		step.configuration.progressBarEnabled = false
		step.configuration.skipEnabled = true
		step.configuration.skipButtonTitle = jsonStep.skipButtonTitle ?? "Not now"
		step.configuration.continueButtonTitle = jsonStep.continueButtonTitle ?? "Turn on notifications"

		return step
	}
}

extension NotificationsStep {
	static let mock = Self(
		configuration: StepBasicConfiguration(
			title: "Receive reminders to take care of your smile",
			description: "Enjoy thousands of personalized expert tips and articles in line with your daily habits.",
			continueButtonTitle: "Turn on notifications",
			progressBarEnabled: false,
			skipEnabled: true,
			skipButtonTitle: "Not now"
		),
		image: "image_name"
	)
}
