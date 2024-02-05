import Foundation
@_implementationOnly import DataManager

public struct Configuration {
	var style: OnboardingStyle
	var steps: [Step]
	
	static func mapFromJSON(_ jsonConfig: JSONConfiguration) -> Configuration {
		Configuration(
			style: jsonConfig.style,
			steps: jsonConfig.steps.map { Step.map(fromJSON: $0) }
		)
	}
}

extension Configuration {
	public static func loadFromFile(withName name: String) throws -> Self {
		guard
			let filePath = Bundle.main.path(forResource: name, ofType: "json")
		else {
			fatalError("OnboardingKit configuration file not found")
		}
		
		let jsonConfiguration = try DataReader<JSONConfiguration>
			.localJSONFile
			.load(URL(fileURLWithPath: filePath))
		
		return Self.mapFromJSON(jsonConfiguration)
	}
	
	public static func loadFromURL(_ url: URL) throws -> Self {
		let jsonConfiguration = try DataReader<JSONConfiguration>
			.localJSONFile
			.load(url)

		return Self.mapFromJSON(jsonConfiguration)
	}
}

extension Configuration {
	static let mock = Configuration(
		style: OnboardingStyle(),
		steps: [
			.welcome(.mock),
			.textInput(.mock),
			.select(.mock),
			.intermediate(.mock),
		]
	)
}

// MARK: Step
struct StepBasicConfiguration: Decodable, Equatable {
	var property: String?
	var title: String?
	var description: String?
	var information: String?
	var continueButtonTitle: String
	var progressBarEnabled: Bool
	var progressBarTitle: String
	var skipEnabled: Bool
	var skipButtonTitle: String?
	var backEnabled: Bool
	
	init(
		property: String? = nil,
		title: String? = nil,
		description: String? = nil,
		information: String? = nil,
		continueButtonTitle: String = "Continue",
		progressBarEnabled: Bool = true,
		progressBarTitle: String = "",
		skipEnabled: Bool = false,
		skipButtonTitle: String? = "Skip",
		backEnabled: Bool = false
	) {
		self.property = property
		self.title = title
		self.description = description
		self.information = information
		self.continueButtonTitle = continueButtonTitle
		self.progressBarEnabled = progressBarEnabled
		self.progressBarTitle = progressBarTitle
		self.skipEnabled = skipEnabled
		self.skipButtonTitle = skipButtonTitle
		self.backEnabled = backEnabled
	}
	
	static func defaultMapping(fromJSON json: JSONStep) -> StepBasicConfiguration {
		StepBasicConfiguration(
			property: json.property,
			title: json.title,
			description: json.description,
			information: json.information,
			continueButtonTitle: json.continueButtonTitle ?? "Continue",
			progressBarEnabled: json.progressBarEnabled ?? true,
			progressBarTitle: json.progressBarTitle ?? " ",
			skipEnabled: json.skipEnabled ?? false,
			skipButtonTitle: json.skipButtonTitle ?? "Skip",
			backEnabled: json.backEnabled ?? false
		)
	}
}
								 
extension StepBasicConfiguration {
	static let mock = StepBasicConfiguration(
		property: nil,
		title: "Hello world",
		description: "Nullam mattis **ullamcorper** nulla nec vehicula.",
		information: "Cras laoreet pretium neque, in tempus sapien. Nam urna neque, ultrices vitae dolor vel, facilisis malesuada nibh.",
		continueButtonTitle: "Continue",
		progressBarEnabled: true,
		progressBarTitle: "Progress",
		skipEnabled: false,
		skipButtonTitle: "Skip",
		backEnabled: true
	)
}

enum Step: Decodable {
	case welcome(WelcomeStep)
	case textInput(InputStep)
	case select(SelectStep)
	case picker(PickerStep)
	case intermediate(IntermediateStep)
	case notification(NotificationsStep)
	case loading(LoadingStep)
	case custom(CustomStep)
	
	static func map(fromJSON jsonStep: JSONStep) -> Step {
		switch jsonStep.type {
		case "welcome":
			return .welcome(WelcomeStep.createFromJSONStep(jsonStep))

		case "select":
			return .select(SelectStep.createFromJSONStep(jsonStep))

		case "intermediate":
			return .intermediate(IntermediateStep.createFromJSONStep(jsonStep))

		case "text_input":
			return .textInput(InputStep.createFromJSONStep(jsonStep))

		case "picker":
			return .picker(PickerStep.createFromJSONStep(jsonStep))

		case "notification":
			return .notification(NotificationsStep.createFromJSONStep(jsonStep))

		case "loading":
			return .loading(LoadingStep.createFromJSONStep(jsonStep))

		case "custom":
			return .custom(CustomStep.createFromJSONStep(jsonStep))
		default:
			fatalError("Missing Step Type \(jsonStep.type) definition")
		}
	}
	
	var configuration: StepBasicConfiguration {
		switch self {
		case .welcome(let step):
			return step.configuration
		case .textInput(let step):
			return step.configuration
		case .select(let step):
			return step.configuration
		case .intermediate(let step):
			return step.configuration
		case .picker(let step):
			return step.configuration
		case .loading(let step):
			return step.configuration
		case .notification(let step):
			return step.configuration
		case .custom(let step):
			return step.configuration
		}
	}

	var showTopBarSkip: Bool {
		switch self {
		case .notification:
			return false
		default:
			return configuration.skipEnabled
		}
	}

	var name: String {
		switch self {
		case .welcome:
			"welcome"
		case .textInput:
			"textInput"
		case .select:
			"select"
		case .picker:
			"picker"
		case .intermediate:
			"intermediate"
		case .notification:
			"notification"
		case .loading:
			"loading"
		case .custom:
			"custom"
		}
	}
}

extension Step: Equatable {
	public static func == (lhs: Step, rhs: Step) -> Bool {
		switch (lhs, rhs) {
		case let (.welcome(lhsData), .welcome(rhsData)):
			return lhsData == rhsData

		case let (.select(lhsData), .select(rhsData)):
			return lhsData == rhsData
			
		case let (.intermediate(lhsData), .intermediate(rhsData)):
			return lhsData == rhsData

		case let (.textInput(lhsData), .textInput(rhsData)):
			return lhsData == rhsData

		case let (.picker(lhsData), .picker(rhsData)):
			return lhsData == rhsData

		case let (.notification(lhsData), .notification(rhsData)):
			return lhsData == rhsData

		case let (.loading(lhsData), .loading(rhsData)):
			return lhsData == rhsData

		default:
			return false
		}
	}
}

enum MediaPosition: String, Decodable {
	case aboveTitle = "above_title"
	case belowTitle = "below_title"
	case belowDescription = "below_description"
}

enum MediaType: Decodable, Equatable, Hashable {
	case image(String)
	case animation(String)
	case video(String)
	
	var media: String {
		switch self {
		case .image(let string):
			return string
		case .animation(let string):
			return string
		case .video(let string):
			return string
		}
	}
}

enum ImageSize: String, Decodable {
	case large
	case medium
	case small
	
	var ratio: CGFloat {
		switch self {
		case .large:
			1
		case .medium:
			2/3
		case .small:
			1/2
		}
	}
}

protocol StepTypeConfiguration: Decodable, Equatable {
	var configuration: StepBasicConfiguration { get }

	static func createFromJSONStep(_ jsonStep: JSONStep) -> Self
}
