import SwiftUI

struct InputStepView: View {
	enum FocusField: Hashable {
		case field
	}

	@Environment(\.onboadingStyle) private var style: OnboardingStyle

	let configuration: InputStep
	@Binding var output: [String: String]

	let continueButtonAction: () -> Void

	@State private var inputText: String = ""
	@FocusState private var focused: FocusField?

	private var keyboardType: UIKeyboardType {
		switch configuration.mode {
		case .text:
			return .default
		case .email:
			return .emailAddress
		case .phone:
			return .phonePad
		case .number:
			return .numberPad
		}
	}

    var body: some View {
		VStack {
			TitleView(
				title: configuration.title ?? "",
				description: configuration.description,
				properties: output
			)
			TextField(configuration.placeholder, text: $inputText)
				.font(style.title2Font)
				.tint(style.mainColor)
				.multilineTextAlignment(style.contentLeftAligned ? .leading : .center)
				.padding()
				.focused($focused, equals: .field)
				.keyboardType(keyboardType)
				.task {
					self.focused = .field
				}
			
			Spacer()
			BottomView(
				information: configuration.information,
				buttonTitle: configuration.continueButtonTitle,
				properties: output,
				buttonAction: {
					defer {
						continueButtonAction()
					}

					guard let property = configuration.property else {
						return
					}
					output[property] = inputText
				}
			)
		}
    }
}

struct InputStepView_Preview: PreviewProvider {
	static var previews: some View {
		InputStepView(
			configuration: .mock,
			output: .constant([:]),
			continueButtonAction: {}
		)
	}
}
