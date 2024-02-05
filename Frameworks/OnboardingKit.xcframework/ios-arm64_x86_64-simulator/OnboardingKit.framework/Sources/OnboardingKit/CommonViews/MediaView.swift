import SwiftUI

struct MediaView: View {
	var media: MediaType
	var imageSize: ImageSize

	var body: some View {
		switch media {
		case .image(let string):
			if let uiImage = loadUIImage(named: string) {
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFit()
					.frame(width: UIScreen.main.bounds.width * imageSize.ratio)
			} else {
				placeholder
			}
						
		case .video(let string):
			// TODO: implement video layer
			Text(string)
				.multilineTextAlignment(.center)
				.padding()
				.background(Rectangle().fill(Color.gray))
			
		default:
			EmptyView()
		}
	}

	private func loadUIImage(named name: String) -> UIImage? {
		UIImage(named: name)
	}
	
	var placeholder: some View {
			VStack(spacing: 5) {
				Image(systemName: "photo.artframe")
				Text("Placeholder")
			}
			.foregroundColor(.white)
			.font(.title)
			.frame(
				width: UIScreen.main.bounds.width * imageSize.ratio,
				height: UIScreen.main.bounds.width * imageSize.ratio
			)
			.background(.gray)
	}
}

struct MediaView_Preview: PreviewProvider {
	static var previews: some View {
		MediaView(media: MediaType.image(""), imageSize: .large)
	}
}
