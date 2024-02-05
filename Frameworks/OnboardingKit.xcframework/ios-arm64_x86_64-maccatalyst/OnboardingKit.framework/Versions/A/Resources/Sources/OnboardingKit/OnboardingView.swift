import SwiftUI

public enum NextStepType {
	case custom(name: String, type: String)
	case other(String)
	
	var name: String {
		switch self {
		case .custom:
			"custom"
		case .other(let string):
			string
		}
	}
}

public struct NextStep {
	public var type: NextStepType
	public var stepPosition: Int
	public var paramsValue: [String: String]
	
	public var name: String {
		type.name
	}
}

/// With ``OnboardingView``, you have a powerful tool at your disposal to create engaging and user-friendly onboarding experiences with minimal effort.
/// Whether you prefer loading your configuration from a local file or a remote URL, ``OnboardingView`` has got you covered.
/// Enjoy crafting your onboarding flows and welcome your users with style!
public struct OnboardingView: View {
	private let configuration: Configuration
	private var viewPaddingTop: CGFloat = 0
	private var onDismiss: ([String: String]) -> Void
	private	var handleNextStep: ((NextStep) -> Void)? = nil
	private var triggeredEvent: ((OnboardingEvent) -> Void)?  = nil
	private var customViewProvider: ((CustomViewInput) -> AnyCustomStepView)?  = nil

	@State private var currentStepValue: Int
	@State private var output: [String: String]
	@State private var progressValue: Float = 0
	@State private var isActive = false
		
	/// Creates an ``OboardingView`` from a file located in the main bundle of the application
	///
	///```swift
	/// OnboardingView(file: "onboardingConfig") { event in
	///		print("User interacted with: \(event)")
	///	} onDismiss: { selections in
	///		print("User selections: \(selections)")
	///	} customViewProvider: { customInput in
	///		switch customInput.viewName {
	///			case "pizza":
	///				AnyCustomStepView(PizzaView()) {
	///					print("Custom Action has been triggered before next step")
	///				}
	///			case "pasta":
	///				AnyCustomStepView(PastaView(
	///					parameters: customInput.properties,
	///					continueTrigger: customInput.continueTrigger)
	///				)
	///			default:
	///				AnyCustomStepView(PizzaView())
	///			}
	///		}
	///	)
	///	```
	///
	/// - Parameters:
	///    - file: A String representing the name of the file containing the onboarding configuration. The file should be included in your app's bundle.
	///    - startingPosition: An optional int representing the step number from wich to start the onboarding.
	///    - paramsValues: An optional dictionary of strings representing the parmeters and their values to be injected in the onboading.
	///    - onStepChange: An optional closure that takes a ``NextStep`` and returns Void. This closure is called whenever a new Step will be displayed.
	///    - onEventTrigger: An optional closure that takes an ``OnboardingEvent`` and returns Void. This closure is called whenever a user interacts with the onboarding view.
	///    - onDismiss: A closure that takes a dictionary with String keys and String values, and returns Void. This closure is called when the onboarding is dismissed, providing the selections made by the user.
	///    - customViewProvider: A closure that takes a dictionary of ``CustomViewInput`` and returns a View of type ``AnyCustomStepView``. This closure is called when a step of type custom should be displayed.
	public init(
		file: String,
		paddingTop: CGFloat = 0,
		startingPosition: Int = 1,
		paramsValues: [String: String] = [:],
		onStepChange: ((NextStep) -> Void)? = nil,
		onEventTrigger: ((OnboardingEvent) -> Void)? = nil,
		onDismiss: @escaping ([String: String]) -> Void,
		customViewProvider: ((CustomViewInput) -> AnyCustomStepView)? = nil
	) {
		self.init(
			configuration: try! Configuration.loadFromFile(withName: file),
			paddingTop: paddingTop,
			startingPosition: startingPosition,
			paramsValues: paramsValues,
			onStepChange: onStepChange,
			onEventTrigger: onEventTrigger,
			onDismiss: onDismiss,
			customViewProvider: customViewProvider
		)
	}
	
	/// Creates an ``OboardingView`` from a file located in the main bundle of the application
	///
	///```swift
	/// OnboardingView(file: "onboardingConfig") { event in
	///		print("User interacted with: \(event)")
	///	} onDismiss: { selections in
	///		print("User selections: \(selections)")
	///	}
	///	```
	///
	/// - Parameters:
	///    - url: A URL pointing to the location of the file containing the onboarding configuration. This could be a file on the device or a file located on a remote server.
	///    - startingPosition: An optional int representing the step number from wich to start the onboarding.
	///    - paramsValues: An optional dictionary of strings representing the parmeters and their values to be injected in the onboading.
	///    - onStepChange: An optional closure that takes a ``NextStep`` and returns Void. This closure is called whenever a new Step will be displayed.
	///    - onEventTrigger: An optional closure that takes an ``OnboardingEvent`` and returns Void. This closure is called whenever a user interacts with the onboarding view.
	///    - onDismiss: A closure that takes a dictionary with String keys and String values, and returns Void. This closure is called when the onboarding is dismissed, providing the selections made by the user.
	public init(
		url: URL,
		startingPosition: Int = 1,
		paramsValues: [String: String] = [:],
		onStepChange: ((NextStep) -> Void)? = nil,
		onEventTrigger: ((OnboardingEvent) -> Void)? = nil,
		onDismiss: @escaping ([String: String]) -> Void
	) {
		self.init(
			configuration: try! Configuration.loadFromURL(url),
			startingPosition: startingPosition,
			paramsValues: paramsValues,
			onStepChange: onStepChange,
			onEventTrigger: onEventTrigger,
			onDismiss: onDismiss
		)
	}
	
	public init(
		configuration: Configuration,
		paddingTop: CGFloat = 0,
		startingPosition: Int = 1,
		paramsValues: [String: String] = [:],
		onStepChange: ((NextStep) -> Void)? = nil,
		onEventTrigger: ((OnboardingEvent) -> Void)? = nil,
		onDismiss: @escaping ([String: String]) -> Void,
		customViewProvider: ((CustomViewInput) -> AnyCustomStepView)? = nil
	) {
		self.configuration = configuration
		self.viewPaddingTop = paddingTop
		self.onDismiss = onDismiss
		self._output = State(initialValue: paramsValues)
		self._currentStepValue = State(initialValue: startingPosition - 1)
		self.handleNextStep = onStepChange
		self.triggeredEvent = onEventTrigger
		self.customViewProvider = customViewProvider
	}
	
	@State private var fullScreen = false
	private let hapticFeedback = UIImpactFeedbackGenerator(style: .soft)
	private var currentStep: Step {
		configuration.steps[currentStepValue]
	}
	
	public var body: some View {
		NavigationView {
			StepContainerView(
				step: currentStep,
				numberOfSteps: configuration.steps.count,
				currentStep: currentStepValue,
				onAction: performNextAction,
				onEventTrigger: triggeredEvent,
				output: $output,
				customViewProvider: customViewProvider
			)
			.ignoresSafeArea(fullScreen ? .all : [])
			.padding(.top, viewPaddingTop)
			.foregroundColor(configuration.style.textColor)
			.animation(.default, value: isActive)
			.opacity(isActive ? 0.0 : 1.0)
			.onboardingStyle(configuration.style)
			.navigationBarTitleDisplayMode(.inline)
			.background(configuration.style.backgroundColor)
			.toolbar {
				if currentStep.configuration.backEnabled {
					backButton
				}
				if currentStep.configuration.progressBarEnabled {
					progressBar
				}
				if currentStep.showTopBarSkip {
					skipButton
				}
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.accentColor(configuration.style.mainColor)
		.onAppear {
			triggeredEvent?(DefaultEvent.start.event())
			triggeredEvent?(DefaultEvent.pageView.event(withParams: ["number": currentStepValue]))

			UIApplication.shared.isIdleTimerDisabled = true
			
			stepWillChange()
			checkFullScreen()
		}
		.onDisappear {
			UIApplication.shared.isIdleTimerDisabled = false
		}
		.onChange(of: currentStep) { _ in
			stepWillChange()
			
			checkFullScreen()
		}
	}
	
	private func checkFullScreen() {
		switch currentStep {
		case .custom(let config):
			fullScreen = config.type == .fullScreen
		default:
			fullScreen = false
		}
	}

	private var backButton: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Button(
				action: performPreviousAction,
				label: {
					Image(systemName: "chevron.backward.circle.fill")
				}
			)
		}
	}
	
	private var progressBar: some ToolbarContent {
		ToolbarItem(placement: .principal) {
			VStack {
				Text(currentStep.configuration.progressBarTitle)
					.font(.headline)
					.foregroundStyle(configuration.style.textColor)
				
				if configuration.style.progressBarSeparatedSteps {
					HStack(spacing: 2) {
						ForEach(configuration.steps.indices, id: \.self) { index in
							ProgressView(
								value: index <= currentStepValue ? 1.0 : 0.0
							)
							.progressViewStyle(
								LinearProgressViewStyle(tint: configuration.style.mainColor)
							)
						}
					}
					.animation(.easeOut, value: currentStepValue)
					.frame(maxWidth: .infinity)

				} else {
					ProgressView(
						value: progressValue
					)
					.progressViewStyle(
						LinearProgressViewStyle(tint: configuration.style.mainColor)
					)
				}
			}
			.frame(maxWidth: 250)
		}
	}

	private var skipButton: some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			Button(
				action: performNextAction,
				label: {
					Text(currentStep.configuration.skipButtonTitle ?? "")
				}
			)
		}
	}
}

extension OnboardingView {
	private func stepWillChange() {
		switch currentStep {
		case .custom(let customStep):
			handleNextStep?(
				NextStep(
					type: .custom(name: customStep.name, type: customStep.type.rawValue),
					stepPosition: currentStepValue + 1,
					paramsValue: output
				)
			)
		default:
			handleNextStep?(
				NextStep(
					type: .other(currentStep.name),
					stepPosition: currentStepValue + 1,
					paramsValue: output
				)
			)
		}
	}

	private func performNextAction() {
		if configuration.style.hapticEnabled {
			hapticFeedback.impactOccurred()
		}
		
		triggeredEvent?(tapContinueEvent())
		
		guard currentStepValue < configuration.steps.count - 1 else {
			triggeredEvent?(DefaultEvent.finish.event())
			onDismiss(output)
			return
		}
		
		guard configuration.style.fadeTransition else {
			currentStepValue += 1
			return
		}
		
		animatePageTransition(
			withNewProgressValue: (Float(currentStepValue) + 1.0) / Float(configuration.steps.count)
		) {
			currentStepValue += 1
		}
	}
	
	private func performPreviousAction() {
		guard currentStepValue > 0 else {
			return
		}

		guard configuration.style.fadeTransition else {
			currentStepValue -= 1
			return
		}

		animatePageTransition(
			withNewProgressValue: (Float(currentStepValue) - 1.0) / Float(configuration.steps.count)
		) {
			currentStepValue -= 1
		}
	}
	
	private func animatePageTransition(
		withNewProgressValue value: Float,
		whileRunningAction action: @escaping () -> Void
	) {
		let animationDuration = Double(configuration.style.transitionDuration) / 1_000
		Task {
			try? await Task.sleep(for: .seconds(animationDuration))
			action()
		}

		withAnimation(.easeOut(duration: animationDuration)) {
			isActive.toggle()
		}

		withAnimation(
			.easeIn(duration: animationDuration)
			.delay(animationDuration)
		) {
			progressValue = value
			isActive.toggle()
		}
	}
	
	private func tapContinueEvent() -> OnboardingEvent {
		guard let property = currentStep.configuration.property else {
			return DefaultEvent.tapContinue.event(
				withParams: [
					"number": currentStepValue
				]
			)
		}

		return DefaultEvent.tapContinue.event(
			withParams: [
				"number": currentStepValue,
				"option": output[property] ?? ""
			]
		)
	}
}

struct OnboadingView_Preview: PreviewProvider {
	static var previews: some View {
		OnboardingView(
			configuration: .mock,
			onEventTrigger: { _ in }, 
			onDismiss: { _ in }
		)
	}
}
