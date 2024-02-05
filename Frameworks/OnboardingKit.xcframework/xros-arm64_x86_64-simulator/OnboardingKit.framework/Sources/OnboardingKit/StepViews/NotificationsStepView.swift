import SwiftUI

struct NotificationsStepView: View {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle

	let configuration: NotificationsStep
	let properties: [String: String]
	let continueButtonAction: () -> Void
	var triggeredEvent: ((OnboardingEvent) -> Void)?

    var body: some View {
		VStack {
			Spacer()
			
			if let image = configuration.image {
				MediaView(media: .image(image), imageSize: .large)
			}

			if let title = configuration.title {
				Text(LocalizedStringKey(stringLiteral: title, properties: properties))
					.font(style.titleFont)
					.padding(.horizontal, 16)
					.padding([.bottom], 40)
			}

			if let description = configuration.description {
				Text(LocalizedStringKey(stringLiteral: description, properties: properties))
					.font(style.bodyTextFont)
					.padding(.horizontal, 16)
			}
			
			Spacer()
			BottomView(
				information: configuration.information,
				buttonTitle: configuration.continueButtonTitle,
				properties: properties,
				buttonAction: {
					Task {
						await handleNotifications()
					}
				}
			)

			if configuration.skipEnabled {
				Button(
					action: continueButtonAction,
					label: {
						Text(LocalizedStringKey(stringLiteral: configuration.skipButtonTitle ?? "", properties: properties))
							.tint(style.mainColor)
							.bold()
					}
				)
				.padding(.top, 10)
			}
		}
		.multilineTextAlignment(.center)
    }
	
	private func handleNotifications() async {
		defer {
			continueButtonAction()
		}

		let notificationCenter = UNUserNotificationCenter.current()
		switch await notificationCenter.notificationSettings().authorizationStatus {
		case .notDetermined:
			guard 
				let grant = try? await notificationCenter
					.requestAuthorization(options: [.sound, .alert, .badge])
			else {
				return
			}
			triggeredEvent?(
				grant ?
					DefaultEvent.notificationActivate.event() :
					DefaultEvent.notificationDeactivate.event()
			)
		default:
			return
		}
	}
}

struct NotificationsStepView_Preview: PreviewProvider {
	static var previews: some View {
		NotificationsStepView(
			configuration: .mock,
			properties: [:],
			continueButtonAction: {}
		)
		.padding(20)
	}
}
