@_implementationOnly import ProgressViews
import SwiftUI

struct LoadingStepView: View {
	@Environment(\.onboadingStyle)  private var style: OnboardingStyle

	let configuration: LoadingStep
	let properties: [String: String]
	let continueButtonAction: () -> Void
	
	private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
	@State private var progress = 0.0
	@State private var currentStep = -1
	
	private var totalSteps: Int {
		(configuration.loadingSteps.isEmpty || configuration.loadingSteps.count == 1) ? 5 : configuration.loadingSteps.count
	}
	
	private var completeLoading: Bool {
		currentStep >= totalSteps
	}

	private static let progressMaxSize = 330.0
	
    var body: some View {
		VStack {
			if !completeLoading {
				Spacer()

				TitleView(
					title: configuration.loadingTitle,
					description: configuration.description, 
					properties: properties
				)

				CircularProgressView(
					progress: progress,
					strokeWidth: 50,
					progressColor: .color(style.mainColor),
					backgroundColor: .color(style.secondaryColor)
				) {
					Color.clear
						.animatingOverlay(for: progress * 100)
				}
				.frame(maxWidth: Self.progressMaxSize)
				.padding(30)
				.padding(.horizontal, 16)
				
				if currentStep >= 0 && currentStep < configuration.loadingSteps.count {
					Text(configuration.loadingSteps[currentStep])
				}
				Spacer()
			} else {
				Spacer()

				if !configuration.completedTitle.isEmpty {
					Text(LocalizedStringKey(stringLiteral: configuration.completedTitle, properties: properties))
						.font(style.titleFont)
						.padding(.bottom, 16)
				}

				if !configuration.completedDescription.isEmpty {
					Text(LocalizedStringKey(stringLiteral: configuration.completedDescription, properties: properties))
						.font(style.bodyTextFont)
				}
				
				Spacer()
				
				BottomView(
					information: configuration.information,
					buttonTitle: configuration.continueButtonTitle,
					properties: properties,
					buttonAction: continueButtonAction
				)
			}
		}
		.animation(.easeOut, value: progress)
		.onChange(of: completeLoading) { _ in
			if completeLoading && configuration.completedTitle.isEmpty && configuration.completedDescription.isEmpty {
				continueButtonAction()
			}
		}
		.onReceive(timer, perform: { _ in
			progress += 1.0 / Double(totalSteps)
			currentStep += 1
			if progress > 1.0 {
				timer.upstream.connect().cancel()
			}
		})
    }
}

struct AnimatableNumberModifier: AnimatableModifier {
	var number: Double
	
	var animatableData: Double {
		get { number }
		set { number = newValue }
	}
	
	func body(content: Content) -> some View {
		content
			.overlay(
				Text("\(Int(number)) %")
					.font(.largeTitle)
					.bold()
			)
	}
}

extension View {
	func animatingOverlay(for number: Double) -> some View {
		modifier(AnimatableNumberModifier(number: number))
	}
}

struct LoadingStepView_Preview: PreviewProvider {
	static var previews: some View {
		LoadingStepView(
			configuration: .mock,
			properties: [:],
			continueButtonAction: {}
		)
		.padding(20)
	}
}
