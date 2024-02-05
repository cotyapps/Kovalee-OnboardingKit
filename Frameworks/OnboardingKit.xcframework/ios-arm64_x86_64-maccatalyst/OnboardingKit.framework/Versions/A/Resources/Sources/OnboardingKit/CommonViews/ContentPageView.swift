import SwiftUI

struct ContentPageView: View {
	var title: String
	var description: String?
	var media: MediaType?
	var mediaPosition: MediaPosition = .belowTitle
	var imageSize: ImageSize = .large
	var properties: [String: String]

	@State var viewFrame: CGRect = .zero

	var body: some View {
		if let media, !media.media.isEmpty {
			VStack {
				Spacer()
				switch mediaPosition {
				case .aboveTitle:
					MediaView(media: media, imageSize: imageSize)
					TitleView(
						title: title,
						description: description,
						larger: true,
						properties: properties
					)

				case .belowTitle:
					TitleView(
						title: title,
						description: description,
						larger: true,
						properties: properties,
						mediaView: {
							MediaView(media: media, imageSize: imageSize)
						}
					)
					
				case .belowDescription:
					TitleView(
						title: title,
						description: description,
						larger: true,
						properties: properties
					)
					MediaView(media: media, imageSize: imageSize)
						.padding(.top, 16)
				}
				Spacer()
			}
		} else {
			TitleView(
				title: title,
				description: description,
				larger: true,
				properties: properties
			)
		}
	}
	
	private func calculateFrame(withSize size: CGSize) {
		viewFrame = CGRect(
			x: size.width / 2,
			y: size.height / 2,
			width: size.width * imageSize.ratio,
			height: size.height * imageSize.ratio
		)
		print(viewFrame)
	}
}

struct ContentPageView_Preview: PreviewProvider {
	static var previews: some View {
		ContentPageView(
			title: "We love your smile... Let's keep it shining bright!",
			description: "Smile Care gives you personalized recommendations to help you take care of your oral health.",
			media: .image("pizza"),
			mediaPosition: .aboveTitle,
			properties: [:]
		)
	}
}
