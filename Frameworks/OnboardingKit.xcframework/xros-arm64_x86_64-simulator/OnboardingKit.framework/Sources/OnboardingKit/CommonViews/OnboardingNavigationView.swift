import SwiftUI

struct OnboardingNavigationStyle {
	var progressBarTitle: String
	var progressBarSteps: Float
	var progressBarValue: Float
	
	var backButtonEnabled: Bool

	var skipButtonTitle: String
	var skipButtonEnabled: Bool
	
	var primaryColorString: String
	var secondaryColorString: String
	var titleColorString: String
	
	var currentValue: Float {
		progressBarValue/progressBarSteps
	}
	
	var primaryColor: Color {
		Color(hex: primaryColorString)
	}
	
	var secondaryColor: Color {
		Color(hex: secondaryColorString)
	}
	
	var titleColor: Color {
		Color(hex: titleColorString)
	}
}


struct OnboardingNavigationView: View {
	let style: OnboardingNavigationStyle

    var body: some View {
		HStack {
			Button(
				action: {},
				label: {
					Image(systemName: "chevron.backward.circle.fill")
				}
			)
			.disabled(!style.backButtonEnabled)
			Spacer()
			VStack {
				Text(style.progressBarTitle)
					.font(.headline)
					.foregroundStyle(style.titleColor)

				ProgressView(
					value: style.currentValue
				)
				.progressViewStyle(
					LinearProgressViewStyle(
						tint: style.primaryColor
					)
				)
			}
			Spacer()
			
		}
		.foregroundStyle(style.primaryColor)

    }
}

struct OnboardingNavigationView_Preview: PreviewProvider {
	static var previews: some View {
		OnboardingNavigationView(
			style: OnboardingNavigationStyle(
				progressBarTitle: "Progres Bar",
				progressBarSteps: 8.0,
				progressBarValue: 3.0,
				backButtonEnabled: false,
				skipButtonTitle: "Skip",
				skipButtonEnabled: false,
				primaryColorString: "#8A3CAE",
				secondaryColorString: "#E8E8E8",
				titleColorString: "#000000"
			)
		)
	}
}
