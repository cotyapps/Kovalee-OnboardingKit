import OnboardingKit
import KovaleeSDK

public extension OnboardingView {
	init(
		file: String,
		paddingTop: CGFloat = 0,
		startingPosition: Int = 1,
		paramsValues: [String : String] = [:],
		onStepChange: ((OnboardingKit.NextStep) -> Void)? = nil,
		onDismiss: @escaping ([String : String]) -> Void,
		customViewProvider: ((OnboardingKit.CustomViewInput) -> OnboardingKit.AnyCustomStepView)? = nil
	) {
		self.init(
			file: file,
			paddingTop: paddingTop,
			startingPosition: startingPosition,
			paramsValues: paramsValues,
			onStepChange: onStepChange,
			onEventTrigger: { event in
				Kovalee.sendEvent(withName: event.name, andProperties: event.properties)
			},
			onDismiss: { output in
				for (key, value) in output {
					Kovalee.setUserProperty(key: key, value: value)
				}

				onDismiss(output)
			},
			customViewProvider: customViewProvider
		)
	}
}
