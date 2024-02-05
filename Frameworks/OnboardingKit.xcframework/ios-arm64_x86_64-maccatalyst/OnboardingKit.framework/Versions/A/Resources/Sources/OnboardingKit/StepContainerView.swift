import OSLog
import SwiftUI

struct StepContainerView: View {
	let step: Step
	let numberOfSteps: Int
	let currentStep: Int

	var onAction: () -> Void
	var onEventTrigger: ((OnboardingEvent) -> Void)?

	@Binding var output: [String: String]
	var customViewProvider: ((CustomViewInput) -> AnyCustomStepView)?

    var body: some View {
		VStack {
			Spacer()
			
			switch step {
			case .welcome(let configuration):
				WelcomeStepView(
					configuration: configuration,
					properties: output,
					continueButtonAction: onAction
				)

			case .select(let configuration):
				SelectStepView(
					configuration: configuration,
					output: $output,
					continueButtonAction: onAction
				)

			case .intermediate(let configuration):
				IntermediateStepView(
					configuration: configuration, 
					properties: output,
					continueButtonAction: onAction
				)
				
			case .textInput(let configuration):
				InputStepView(
					configuration: configuration,
					output: $output,
					continueButtonAction: onAction
				)

			case .picker(let configuration):
				PickerStepView(
					configuration: configuration,
					output: $output,
					continueButtonAction: onAction
				)

			case .loading(let configuration):
				LoadingStepView(
					configuration: configuration,
					properties: output,
					continueButtonAction: onAction
				)

			case .notification(let configuration):
				NotificationsStepView(
					configuration: configuration,
					properties: output, 
					continueButtonAction: onAction,
					triggeredEvent: onEventTrigger
				)

			case .custom(let configuration):
				CustomStepView(
					configuration: configuration,
					customViewProvider: customViewProvider,
					properties: $output,
					continueButtonAction: onAction
				)
			}
		}
		.onChange(of: output) { newOutput in
			Logger.onboadringKit.debug("Output changed: \(newOutput)")
		}
		.onChange(of: currentStep) { step in
			onEventTrigger?(DefaultEvent.pageView.event(withParams: ["number": step]))
		}
    }
}

struct StepView_Preview: PreviewProvider {
	static var previews: some View {
		StepContainerView(
			step: Step.welcome(.mock),
			numberOfSteps: 8,
			currentStep: 3,
			onAction: {},
			output: .constant([:])
		)
	}
}
