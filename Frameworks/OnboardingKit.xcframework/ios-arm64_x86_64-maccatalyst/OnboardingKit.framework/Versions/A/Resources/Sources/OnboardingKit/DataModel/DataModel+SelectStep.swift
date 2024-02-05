import Foundation

// MARK: Select Step
@dynamicMemberLookup
struct SelectStep {
	var configuration: StepBasicConfiguration

	var options: [SelectOption]
	var iconPosition: IconPosition
	var iconSize: Int
	var multiSelect: Bool
	var directContinue: Bool
	var displayDescriptionOnSelect: Bool

	subscript<T>(dynamicMember keyPath: KeyPath<StepBasicConfiguration, T>) -> T {
		configuration[keyPath: keyPath]
	}
}

extension SelectStep: StepTypeConfiguration {
	static func createFromJSONStep(_ jsonStep: JSONStep) -> Self {
		SelectStep(
			configuration: StepBasicConfiguration.defaultMapping(fromJSON: jsonStep),
			options: jsonStep.selectOptions ?? [],
			iconPosition: jsonStep.iconsPosition ?? .left,
			iconSize: jsonStep.iconsSize ?? 24,
			multiSelect: jsonStep.multiSelect ?? false,
			directContinue: jsonStep.directContinue ?? true,
			displayDescriptionOnSelect: jsonStep.displayDescriptionOnSelect ?? false
		)
	}
}

enum IconPosition: String, Decodable {
	case left
	case right
}

struct SelectOption: Decodable, Equatable, Identifiable {
	var id: UUID
	var title: String
	var description: String?
	var icon: String?
	var reset: Bool?
	
	enum CodingKeys: CodingKey {
		case id
		case title
		case description
		case icon
		case reset
	}
	
	init(
		id: UUID = UUID(),
		title: String,
		description: String? = nil,
		icon: String? = nil,
		reset: Bool? = nil
	) {
		self.id = id
		self.title = title
		self.description = description
		self.icon = icon
		self.reset = reset
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.title = try container.decode(String.self, forKey: .title)
		self.description = try container.decodeIfPresent(String.self, forKey: .description)
		self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
		self.reset = try container.decodeIfPresent(Bool.self, forKey: .reset)
		
		self.id = UUID()
	}
}

// MARK: Mock
extension SelectStep {
	static let mock = {
		SelectStep(
			configuration: .mock,
			options: [
				SelectOption(title: "Male"),
				SelectOption(title: "Female"),
				SelectOption(title: "Prefer not to say"),
			],
			iconPosition: .right,
			iconSize: 20,
			multiSelect: false,
			directContinue: false,
			displayDescriptionOnSelect: false
		)
	}()
	
	static let mockSelectDescription = {
		SelectStep(
			configuration: .mock,
			options: [
				SelectOption(
					title: "Get better",
					description: "I want to become **better** in all areas of my life and achieve my goals."
				),
				SelectOption(
					title: "Get faster",
					description: "I want to get faster and win every race I take part in by far."
				),
				SelectOption(
					title: "Get stronger",
					description: "I want to get stronger and be able to lift mountains, or at least cars."
				),
				SelectOption(
					title: "Get better",
					description: "I want to become **better** in all areas of my life and achieve my goals."
				),
				SelectOption(
					title: "Get faster",
					description: "I want to get faster and win every race I take part in by far."
				),
				SelectOption(
					title: "Get stronger",
					description: "I want to get stronger and be able to lift mountains, or at least cars."
				)
			],
			iconPosition: .right,
			iconSize: 20,
			multiSelect: true,
			directContinue: false,
			displayDescriptionOnSelect: true
		)
	}()
	
	static let mockSelectIcon = {
		SelectStep(
			configuration: .mock,
			options: [
				SelectOption(
					title: "Get better",
					icon: "🚀️"
				),
				SelectOption(
					title: "Get faster",
					icon: "‍🏃"
				),
				SelectOption(
					title: "Get stronger",
					icon: "💪"
				),
			],
			iconPosition: .right,
			iconSize: 20,
			multiSelect: true,
			directContinue: false,
			displayDescriptionOnSelect: false
		)
	}()
	
	static let mockSelectIconDescription = {
		SelectStep(
			configuration: .mock,
			options: [
				SelectOption(
					title: "Get better",
					description: "I want to become better in all areas of my life and achieve my goals.",
					icon: "🚀️"
				),
				SelectOption(
					title: "Get faster",
					description: "I want to get faster and win every race I take part in by far.",
					icon: "‍🏃"
				),
				SelectOption(
					title: "Get stronger",
					description: "I want to get stronger and be able to lift mountains, or at least cars.",
					icon: "💪"
				),
				SelectOption(
					title: "None of the above",
					reset: true
				),
			],
			iconPosition: .left,
			iconSize: 30,
			multiSelect: true,
			directContinue: false,
			displayDescriptionOnSelect: true
		)
	}()
}
