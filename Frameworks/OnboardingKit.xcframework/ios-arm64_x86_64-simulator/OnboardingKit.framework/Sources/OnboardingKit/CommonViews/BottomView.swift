import SwiftUI

struct BottomView: View {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle

	var information: String?
	var buttonTitle: String
	let properties: [String: String]
	var buttonAction: () -> Void
	
	var body: some View {
		if let information {
			Text(LocalizedStringKey(stringLiteral: information, properties: properties))
				.font(.footnote)
				.padding(.bottom, 10)
		}

		Button(LocalizedStringKey(stringLiteral: buttonTitle, properties: properties), action: buttonAction)
			.buttonStyle(BottomButtonStyle())
			.padding()
	}
}

struct BottomButtonStyle: ButtonStyle {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle

	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.bold()
			.foregroundStyle(style.colorFromLuminance(ofColor: style.mainColor))
			.frame(maxWidth: .infinity, maxHeight: 50)
			.background(style.mainColor.opacity(configuration.isPressed ? 0.8 : 1.0))
			.cornerRadius(style.buttonCornerRadius)
	}
}

struct BottomView_Preview: PreviewProvider {
	static var previews: some View {
		BottomView(
			buttonTitle: "Continue",
			properties: [:],
			buttonAction: {}
		)
		.padding()
		
		BottomView(
			information: "Cras laoreet pretium neque, in tempus sapien. Nam urna neque, ultrices vitae dolor vel, facilisis malesuada nibh.",
			buttonTitle: "Continue",
			properties: [:],
			buttonAction: {}
		)
	}
}
