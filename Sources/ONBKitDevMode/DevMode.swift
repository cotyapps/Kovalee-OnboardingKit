import OnboardingKit
import SwiftUI

let OnboardingURL = URL.documentsDirectory.appending(path: "onboarding.json")

public struct OnboardingDevModeView: View {
	enum ViewState {
		case none
		case loading
		case ready(Configuration)
		case error(String)
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

			case let .ready(config):
				OnboardingView(
					configuration: config,
					onDismiss: { _ in
						state = .none
					}
				)

			case let .error(error):
				VStack(spacing: 10) {
					Text("Something went wrong").bold()
						.foregroundStyle(.red)
					Text(error)
						.foregroundStyle(.red)

					Button("Ok") {
						state = .none
					}
					.padding(.top, 20)
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
			let configuration = try Configuration.loadFromURL(OnboardingURL)
			state = .ready(configuration)
		} catch {
			state = .error(error.localizedDescription)
		}
	}
}

#Preview {
	OnboardingDevModeView(documentId: "") {
		
	}
}
