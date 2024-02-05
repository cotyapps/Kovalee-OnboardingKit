import SwiftUI
import UIKit

// MARK: Style
struct OnboardingStyle: Decodable {
	var backgroundColor: Color
	var mainColor: Color
	var secondaryColor: Color
	var textColor: Color
	var titleFontName: String
	var bodyTextFontName: String
	var titleFontSize: Int
	var bodyFontSize: Int
	var buttonCornerRadius: CGFloat
	var fadeTransition: Bool
	var transitionDuration: Int
	var hapticEnabled: Bool
	var contentLeftAligned: Bool
	var selectOptionsLeftAligned: Bool
	var progressBarSeparatedSteps: Bool

	var titleFont: Font {
		customFont(
			name: titleFontName,
			size: Double(titleFontSize),
			alternative: .system(size: Double(titleFontSize))
		)
	}
	
	var title2Font: Font {
		customFont(
			name: titleFontName,
			size: Double(titleFontSize) + 2,
			alternative: .system(size: Double(titleFontSize) + 2)
		)
	}

	var bodyTextFont: Font {
		customFont(
			name: bodyTextFontName,
			size: Double(bodyFontSize),
			alternative: .system(size: Double(bodyFontSize))
		)
	}
	
	enum CodingKeys: CodingKey {
		case backgroundColor
		case mainColor
		case secondaryColor
		case textColor
		case titleFont
		case bodyTextFont
		case titleFontSize
		case bodyFontSize
		case buttonCornerRadius
		case fadeTransition
		case hapticEnabled
		case transitionDuration
		case contentLeftAligned
		case selectOptionsLeftAligned
		case progressBarSeparatedSteps
	}
	
	init() {
		self.backgroundColor = Color(hex: "#FFFFFF")
		self.mainColor = Color(hex: "#8A3CAE")
		self.secondaryColor = Color(hex: "#E8E8E8")
		self.textColor = Color(hex: "#000000")
		self.titleFontName = "Helvetica-Bold"//
		self.bodyTextFontName = "Helvetica-Regular"
		self.titleFontSize = 32
		self.bodyFontSize = 18
		self.buttonCornerRadius = 16
		self.fadeTransition = true
		self.transitionDuration = 500
		self.hapticEnabled = true
		self.contentLeftAligned = false
		self.selectOptionsLeftAligned = false
		self.progressBarSeparatedSteps = true
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.backgroundColor = Color(hex: try container.decode(String.self, forKey: .backgroundColor))
		self.mainColor = Color(hex: try container.decode(String.self, forKey: .mainColor))
		self.secondaryColor = Color(hex: try container.decode(String.self, forKey: .secondaryColor))
		self.textColor = Color(hex: try container.decode(String.self, forKey: .textColor))
		
		self.titleFontName = try container.decode(String.self, forKey: .titleFont)
		self.bodyTextFontName = try container.decode(String.self, forKey: .bodyTextFont)
		
		self.titleFontSize = try container.decode(Int.self, forKey: .titleFontSize)
		self.bodyFontSize = try container.decode(Int.self, forKey: .bodyFontSize)
		
		self.buttonCornerRadius = CGFloat(try container.decode(Float.self, forKey: .buttonCornerRadius))
		self.fadeTransition = try container.decode(Bool.self, forKey: .fadeTransition)
		self.transitionDuration = Int(try container.decode(Float.self, forKey: .transitionDuration))
		self.hapticEnabled = try container.decode(Bool.self, forKey: .hapticEnabled)
		self.contentLeftAligned = try container.decodeIfPresent(Bool.self, forKey: .contentLeftAligned) ?? false
		self.selectOptionsLeftAligned = try container.decodeIfPresent(Bool.self, forKey: .selectOptionsLeftAligned) ?? false

		self.progressBarSeparatedSteps = try container.decode(Bool.self, forKey: .progressBarSeparatedSteps)
	}
}

extension OnboardingStyle {
	func colorFromLuminance(ofColor color: Color) -> Color {
		color.hexToLuminance() > 0.5 ? .black : .white
	}
}

private struct OnboardingStyleKey: EnvironmentKey {
	static let defaultValue: OnboardingStyle = OnboardingStyle()
}

extension EnvironmentValues {
	var onboadingStyle: OnboardingStyle {
		get { self[OnboardingStyleKey.self] }
		set { self[OnboardingStyleKey.self] = newValue }
	}
}

extension View {
	func onboardingStyle(_ style: OnboardingStyle) -> some View {
		environment(\.onboadingStyle, style)
	}
}

func isFontAvailable(_ fontName: String) -> Bool {
	UIFont.familyNames.contains(where: {
		UIFont.fontNames(
			forFamilyName: $0
		).contains(
			fontName
		)
	})
}

// Function to get the SwiftUI Font
func customFont(name fontName: String, size: CGFloat, alternative: Font = .body) -> Font {
	if isFontAvailable(fontName) {
		return Font.custom(fontName, size: size)
	} else {
		return alternative
	}
}
