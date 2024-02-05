import Foundation

// MARK: Welcome Step
@dynamicMemberLookup
struct WelcomeStep {
	var configuration: StepBasicConfiguration

	var content: [WelcomeContent]
	var backgroundImage: String?
	var continueMode: ContinueMode
	
	enum ContinueMode: String, Decodable, Equatable {
		case nextStep = "next_step"
		case nextCarrouselPage = "next_carrousel_page"
	}

	subscript<T>(dynamicMember keyPath: KeyPath<StepBasicConfiguration, T>) -> T {
		configuration[keyPath: keyPath]
	}
}

extension WelcomeStep: StepTypeConfiguration {
	static func createFromJSONStep(_ step: JSONStep) -> Self {
		var step = WelcomeStep(
			configuration: StepBasicConfiguration.defaultMapping(fromJSON: step),
			content: step.content ?? [],
			backgroundImage: step.backgroundImage,
			continueMode: step.continueMode ?? .nextCarrouselPage
		)

		step.configuration.progressBarEnabled = false
		step.configuration.progressBarTitle = ""
		step.configuration.skipEnabled = false
		step.configuration.skipButtonTitle = nil
		step.configuration.continueButtonTitle = "Get started"
		
		return step
	}
}

struct WelcomeContent: Decodable, Equatable, Identifiable, Hashable {
	var id: UUID
	
	var title: String
	var description: String?
	var media: MediaType?
	var mediaPosition: MediaPosition? = .aboveTitle
	var imageSize: ImageSize? = .large
	
	enum CodingKeys: CodingKey {
		case title
		case description
		case image
		case video
		case lottie
		case mediaPosition
		case imageSize
	}

	init(
		id: UUID = UUID(),
		title: String,
		description: String? = nil,
		media: MediaType? = nil,
		mediaPosition: MediaPosition? = .aboveTitle,
		imageSize: ImageSize = .large
	) {
		self.id = id
		self.title = title
		self.description = description
		self.media = media
		self.mediaPosition = mediaPosition
		self.imageSize = imageSize
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.title = try container.decode(String.self, forKey: .title)
		self.description = try container.decodeIfPresent(String.self, forKey: .description)
		if let image = try container.decodeIfPresent(String.self, forKey: .image) {
			self.media = .image(image)
		}
		if let video = try container.decodeIfPresent(String.self, forKey: .video) {
			self.media = .video(video)
		}
		if let lottie = try container.decodeIfPresent(String.self, forKey: .lottie) {
			self.media = .animation(lottie)
		}
		self.mediaPosition = try container.decodeIfPresent(MediaPosition.self, forKey: .mediaPosition) ?? .aboveTitle
		
		if let imageSize = try container.decodeIfPresent(String.self, forKey: .imageSize) {
			self.imageSize = ImageSize(rawValue: imageSize)
		}
		
		self.id = UUID()
	}
}

// MARK: Mock
extension WelcomeStep {
	static let mock: WelcomeStep = {
		WelcomeStep(
			configuration: .mock, 
			content: [
				WelcomeContent(
					title: "Page 0",
					description: "Welcome!",
					media: .video("WelcomeImage"),
					imageSize: .large
				),
				WelcomeContent(
					title: "Page 1",
					description: "Welcome!",
					mediaPosition: .aboveTitle,
					imageSize: .medium
				),
				WelcomeContent(
					title: "Page 2",
					description: "Welcome!",
					mediaPosition: .belowTitle,
					imageSize: .large
				),
				WelcomeContent(
					title: "Page 3",
					description: "Welcome!",
					mediaPosition: .belowDescription,
					imageSize: .small
				)
			],
			continueMode: .nextCarrouselPage
		)
	}()
	
	static let mockSinglePage: WelcomeStep = {
		WelcomeStep(
			configuration: .mock,
			content: [
				WelcomeContent(
					title: "We love your smile... Let's keep it shining bright!",
					description: "Smile Care gives you personalized recommendations to help you take care of your oral health.",
					media: .image("pizza"),
					imageSize: .medium
				)
			],
			continueMode: .nextCarrouselPage
		)
	}()
}
