import OnboardingKit
import SwiftUI

public struct KovaleeOnboardingKit: View {
	
	private let file: String
	private var triggeredEvent: ((OnboardingEvent) -> Void)?
	private var onDismiss: ([String: String]) -> Void
	
	public init(
		file: String,
		onEventTrigger: ((OnboardingEvent) -> Void)? = nil,
		onDismiss: @escaping ([String: String]) -> Void
	) {
		self.file = file
		self.triggeredEvent = onEventTrigger
		self.onDismiss = onDismiss
	}
	
	public var body: some View {
		OnboadingView(
			file: file,
			onEventTrigger: triggeredEvent,
			onDismiss: onDismiss
		)
	}
}
