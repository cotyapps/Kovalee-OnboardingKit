import SwiftUI

/// ``CustomViewInput`` is a struct used to encapsulate the input parameters for custom views in an onboarding flow.
/// It includes the name of the view, optional dynamic properties, and a binding to a Boolean value to trigger continuation.
public struct CustomViewInput {

	/// The name of the custom view.
	public var viewName: String

	/// Optional binding to a dictionary of properties that can be used to configure the view.
	public var properties: Binding<[String: String]>?
	
	/// Optional binding to a Boolean value that, when set to true, indicates continuation in the onboarding flow.
	public var continueTrigger: Binding<Bool>?
}

/// ``CustomStepProtocol`` is a protocol for SwiftUI views to conform to when they are used as steps in an onboarding process.
/// It includes optional bindings for continuation triggers and step-specific parameters.
public protocol CustomStepProtocol: View {

	/// Optional binding to a Boolean value that controls the flow of the onboarding process.
	var continueTrigger: Binding<Bool>? { get }
	
	/// Optional binding to a dictionary of parameters that can be used for custom configuration of the step.
	var parameters: Binding<[String: String]>? { get }
}

public extension CustomStepProtocol {
	var continueTrigger: Binding<Bool>? { nil }
	var parameters: Binding<[String: String]>? { nil }
}

/// ``AnyCustomStepView`` is a type-erased view that conforms to ``CustomStepProtocol``.
/// It is used to encapsulate any view that conforms to ``CustomStepProtocol``, allowing for dynamic view composition in an onboarding flow. It also allows for an optional custom action to be executed.
public struct AnyCustomStepView: CustomStepProtocol {
	private var content: AnyView
	public var customAction: (() -> Void)? = nil

	/// Creates an ``AnyCustomStepView`` with a view conforming to ``CustomStepProtocol`` and an optional customAction that will be triggered before continuing to the next step.
	///
	/// - Parameters:
	///    - content: a view conforming to ``CustomStepProtocol``
	///    - customAction: optional function that will be triggered before continuing to the next step
	public init<Content: View & CustomStepProtocol>(_ content: Content, customAction: (() -> Void)? = nil) {
		self.content = AnyView(content)
		self.customAction = customAction
	}

	public var body: some View {
		content
	}
}

struct CustomStepView: View {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle
	
	let configuration: CustomStep
	var customViewProvider: ((CustomViewInput) -> AnyCustomStepView)?

	@Binding var properties: [String: String]
	let continueButtonAction: () -> Void

	@State private var continueTriggered = false
	
	var body: some View {
		let customInput = CustomViewInput(
			viewName: configuration.name,
			properties: $properties,
			continueTrigger: $continueTriggered
		)
		let customView = customViewProvider?(customInput)

		VStack {
			if let customView {
				customView
				
				if case .contentOnly = configuration.type {
					Spacer()

					BottomView(
						information: configuration.information,
						buttonTitle: configuration.continueButtonTitle,
						properties: properties,
						buttonAction: {
							customView.customAction?()
							continueButtonAction()
						}
					)
				}
			} else {
				Text("Custom step hasn't loadded correctly")
					.foregroundStyle(.red)
				BottomView(
					information: configuration.information,
					buttonTitle: configuration.continueButtonTitle,
					properties: properties,
					buttonAction: continueButtonAction
				)
			}
		}
		.onChange(of: continueTriggered) { _ in
			if continueTriggered {
				customView?.customAction?()
				continueButtonAction()
			}
		}
	}
}
