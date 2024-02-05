import OSLog
import Foundation

public struct OnboardingEvent {
	public var name: String
	public var properties: [String: Any]? = nil
}

extension OnboardingEvent: CustomStringConvertible {
	public var description: String {
		if let properties {
			return "\(name) with parameters: \(properties)"
		} else {
			return name
		}
	}
}

enum DefaultEvent: String {
	case start = "onboarding_start"
	case finish = "onboarding_finish"
	case pageView = "onboarding_page_view"
	case tapContinue = "onboarding_tap_continue"
	case pageViewPaywall = "page_view_paywall"
	case notificationActivate = "na_notification_activate"
	case notificationDeactivate = "na_notification_deactivate"
	
	func event(withParams params: [String: Any]? = nil) -> OnboardingEvent {
		let event = OnboardingEvent(name: self.rawValue, properties: params)
		Logger.onboadringKit.debug("Triggered Event: \(event.description)")
		return event
	}
}
