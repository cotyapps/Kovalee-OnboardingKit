import SwiftUI

struct IntermediateStepView: View {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle

	let configuration: IntermediateStep
	let properties: [String: String]
	let continueButtonAction: () -> Void
	
	private var title: String {
		configuration.title ?? ""
	}
	
	private var description: String? {
		configuration.description
	}
	
	var body: some View {
		if let image = configuration.image {
			ContentPageView(
				title: title,
				description: description,
				media: .image(image),
				mediaPosition: configuration.mediaPosition,
				imageSize: configuration.imageSize,
				properties: properties
			)
		} else {
			TitleView(
				title: title,
				description: description,
				larger: true,
				properties: properties
			)
		}
		
		Spacer()

		BottomView(
			information: configuration.information,
			buttonTitle: configuration.continueButtonTitle,
			properties: properties,
			buttonAction: continueButtonAction
		)
	}
}

struct IntermediateStepView_Preview: PreviewProvider {
	static var previews: some View {
		IntermediateStepView(
			configuration: .mock, 
			properties: [:],
			continueButtonAction: {}
		)

		IntermediateStepView(
			configuration: .mockImageAboveDescription,
			properties: [:],
			continueButtonAction: {}
		)

		IntermediateStepView(
			configuration: .mockImageAboveDescription,
			properties: [:],
			continueButtonAction: {}
		)
	}
}
