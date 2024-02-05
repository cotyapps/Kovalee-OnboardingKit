import Foundation

// MARK: Picker Step
@dynamicMemberLookup
struct PickerStep: Decodable {
	var configuration: StepBasicConfiguration
	var mode: PickerMode

	enum PickerMode: Decodable, Equatable {
		case hour
		case date
		case year(min: Int, max: Int)
		case custom([PickerOption])

		static func create(
			fromRawValue rawValue: String,
			options: [PickerOption]? = nil,
			years: [String: Int]?
		) -> Self {
			switch rawValue {
			case "hour":
				return .hour
			case "date":
				return .date
				
			case "year":
				let min = years?["min"] ?? 0
				let max = years?["max"] ?? 0
				return .year(min: min, max: max)
			case "custom":
				return .custom(options ?? [])
				
			default:
				return .hour
			}
		}
	}

	subscript<T>(dynamicMember keyPath: KeyPath<StepBasicConfiguration, T>) -> T {
		configuration[keyPath: keyPath]
	}
}

extension PickerStep: StepTypeConfiguration {
	static func createFromJSONStep(_ jsonStep: JSONStep) -> PickerStep {
		Self(
			configuration: StepBasicConfiguration.defaultMapping(fromJSON: jsonStep),
			mode: PickerMode.create(
				fromRawValue: jsonStep.pickerMode ?? "date",
				options: jsonStep.pickerOptions,
				years: ["min": jsonStep.min ?? 0, "max": jsonStep.max ?? 0]
			)
		)
	}
}

struct PickerOption: Decodable, Equatable, Hashable {
	var property: String
	var defaultValue: String?
	var values: [String]
}

extension PickerStep {
	static let mock = Self(
		configuration: StepBasicConfiguration(
			property: "fruit",
			title: "What are your favourite fruits and vegetables?",
			information: "We use this information to personalize your experience by offering you relevant recommendations"
		),
		mode: .custom(
			[
				PickerOption(property: "vegetables", values: ["Tomatoes", "Carrots"]),
				PickerOption(property: "fruits", values: ["Apples", "Lemons"])
			]
		)
	)
	
	static let mockHour = Self(
		configuration: StepBasicConfiguration(
			property: "time",
			title: "What time is it?"
		),
		mode: .hour
	)
	
	static let mockDate = Self(
		configuration: StepBasicConfiguration(
			property: "date",
			title: "What's your date of birth?"
		),
		mode: .date
	)
	
	static let mockYear = Self(
		configuration: StepBasicConfiguration(
			property: "year",
			title: "What is your year of birth?"
		),
		mode: .year(min: 1950, max: 2050)
	)
}
