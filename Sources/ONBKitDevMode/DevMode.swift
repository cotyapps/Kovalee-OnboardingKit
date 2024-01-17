import OnboardingKit
import SwiftUI

let OnboardingURL = URL.documentsDirectory.appending(path: "onboarding.json")

public struct OnboardingDevModeView: View {
	enum ViewState {
		case none
		case loading
		case ready
		case error
	}
	@State private var state: ViewState = .none
	private let onboardingHandler = OnboardingHandler.live
	
	private let documentId: String
	private var onDismiss: () -> Void
	
	public init(documentId: String, onDismiss: @escaping () -> Void) {
		self.documentId = documentId
		self.onDismiss = onDismiss
	}
	
	public var body: some View {
		VStack {
			switch state {
			case .none:
				VStack(spacing: 10) {
					Button("Close", systemImage: "xmark") {
						onDismiss()
					}
					.buttonStyle(.bordered)

					Button("Refresh", systemImage: "arrow.clockwise") {
						Task {
							await retrieveOnboarding(withDocumentId: documentId)
						}
					}
					.buttonStyle(.bordered)
				}

			case .loading:
				ProgressView()

			case .ready:
				OnboardingView(
					url: OnboardingURL,
					onDismiss: { _ in
						state = .none
					}
				)

			case .error:
				VStack(spacing: 10) {
					Text("Something went wrong with the document retrieval")
					
					Button("Ok") {
						state = .none
					}
				}
			}
		}
		.navigationTitle("ONBKit Dev Mode")
		.task {
			await retrieveOnboarding(withDocumentId: documentId)
		}
	}
	
	private func retrieveOnboarding(withDocumentId documentId: String) async {
		state = .loading
		do {
			try await onboardingHandler.retrieveOnboardingWithDocumentId(documentId)
			state = .ready
		} catch {
			state = .error
		}
	}
}

#Preview {
	OnboardingDevModeView(documentId: "") {
		
	}
}
