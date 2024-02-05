import SwiftUI

struct TitleView<MediaView: View>: View {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle

	var title: LocalizedStringKey
	var description: LocalizedStringKey?
	var larger: Bool
	@ViewBuilder private var mediaView: () -> MediaView
	
	init(
		title: String,
		description: String? = nil,
		larger: Bool = false,
		properties: [String: String],
		@ViewBuilder mediaView: @escaping () -> MediaView
	) {
		self.title = LocalizedStringKey(stringLiteral: title, properties: properties)
		if let description {
			self.description = LocalizedStringKey(stringLiteral: description, properties: properties)
		}
		self.mediaView = mediaView
		self.larger = larger
	}
	
	init(
		title: String,
		description: String? = nil,
		larger: Bool = false,
		properties: [String: String]
	) where MediaView == EmptyView {
		self.init(
			title: title,
			description: description,
			larger: larger,
			properties: properties,
			mediaView: { EmptyView() }
		)
	}

	var body: some View {
		VStack {
			Text(title)
				.font(larger ? style.title2Font : style.titleFont )
				.foregroundColor(style.textColor)
			mediaView()
				.padding(.top, 16)

			if let description {
				Text(description)
					.padding(.top, 16)
					.font(style.bodyTextFont)
					.foregroundColor(style.textColor.opacity(0.7))
			}
		}
		.padding()
		.multilineTextAlignment(.center)
	}
}

struct TitleView_Preview: PreviewProvider {
	static var previews: some View {
		TitleView(
			title: "_Hello World_!",
			description: "Nam *urna* neque, ~~ultrices [name] dolor vel~~, **facilisis** malesuada nibh.",
			larger: false,
			properties: ["name": "Pizza man"]
		)
	}
}
