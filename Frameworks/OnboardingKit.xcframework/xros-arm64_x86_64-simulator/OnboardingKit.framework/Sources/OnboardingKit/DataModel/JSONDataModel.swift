import Foundation

struct JSONConfiguration: Decodable {
	var style: OnboardingStyle
	var steps: [JSONStep]
}

struct JSONStep: Decodable {
	var type: String
	var property: String?
	var title: String?
	var description: String?
	var information: String?
	
	var continueButtonTitle: String?
	var progressBarEnabled: Bool?
	var progressBarTitle: String?
	var progressBarSeparatedSteps: Bool?
	
	var skipEnabled: Bool?
	var skipButtonTitle: String?
	
	var backEnabled: Bool?
	
	// Welcome Step
	var content: [WelcomeContent]?
	var backgroundImage: String?
	var continueMode: WelcomeStep.ContinueMode?
	
	// Select Step
	var selectOptions: [SelectOption]?
	var multiSelect: Bool?
	var directContinue: Bool?
	var displayDescriptionOnSelect: Bool?
	var iconsPosition: IconPosition?
	var iconsSize: Int?
	
	// Input Step
	var placeholder: String?
	var inputMode: InputStep.InputMode?
	
	// Picker
	var pickerMode: String?
	var pickerOptions: [PickerOption]?
	var min: Int?
	var max: Int?
	
	// Intermediate
	var image: String?
	var imageSize: ImageSize?
	var imagePosition: MediaPosition?
	
	// Loading
	var loadingSteps: [[String: String]]?
	var loadingTitle: String?
	var completedTitle: String?
	var completedDescription: String?
	
	// Custom
	var customName: String?
	var customStepType: CustomStepType?
}
