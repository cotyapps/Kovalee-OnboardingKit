import SwiftUI

struct WelcomeStepView: View {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle

	let configuration: WelcomeStep
	let properties: [String: String]
	let continueButtonAction: () -> Void

	@State private var selectedPage = 0
	
	private var buttonTitle: String {
		switch configuration.continueMode {
		case .nextCarrouselPage:
			return selectedPage < configuration.content.count - 1 ? "Continue" : configuration.continueButtonTitle
		case .nextStep:
			return configuration.continueButtonTitle
		}
	}
	
	var body: some View {
		VStack {
			TabView (selection: $selectedPage) {
				ForEach(configuration.content) { content in
					ContentPageView(
						title: content.title,
						description: content.description,
						media: content.media,
						mediaPosition: content.mediaPosition ?? .belowTitle,
						imageSize: content.imageSize ?? .large, 
						properties: properties
					)
					.padding(.bottom, 30)
					.foregroundColor(style.textColor)
					.tag(configuration.content.firstIndex(of: content) ?? 0)
				}
			}
			.tabViewStyle(.page)
			.indexViewStyle(.page(backgroundDisplayMode: .always))

			Spacer()

			BottomView(
				information: configuration.information,
				buttonTitle: buttonTitle,
				properties: properties,
				buttonAction: continueAction
			)
		}
	}
	
	private func continueAction() {
		switch configuration.continueMode {
		case .nextCarrouselPage:
			if selectedPage == configuration.content.count - 1 {
				continueButtonAction()
			} else {
				withAnimation {
					selectedPage += 1
				}
			}
		case .nextStep:
			continueButtonAction()
		}
	}
}

struct WelcomeStepView_Preview: PreviewProvider {
	static var previews: some View {
		WelcomeStepView(
			configuration: .mockSinglePage,
			properties: [:],
			continueButtonAction: {}
		)
		
		WelcomeStepView(
			configuration: .mock,
			properties: [:],
			continueButtonAction: {}
		)
	}
}
