import FirebaseCore
import FirebaseFirestore
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
					Button("Close Onboarding") {
						onDismiss()
					}
					
					Button("Refresh onboarding") {
						Task {
							await retrieveOnboarding(withDocumentId: documentId)
						}
					}
				}
				
			case .loading:
				ProgressView()
				
			case .ready:
				OnboardingView(
					url: OnboardingURL,
					onEventTrigger: { _ in },
					onDismiss: { _ in
						state = .none
					}
				)
				
			case .error:
				Text("Something went wrong with the document retrieval")
				
				Button("Ok") {
					state = .none
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

struct OnboardingHandler {
	var retrieveOnboardingWithDocumentId: (String) async throws -> Void
}

extension OnboardingHandler {
	static var live: Self {
		let db = Firestore.firestore()

		return .init(
			retrieveOnboardingWithDocumentId: { documentId in
				let document = try await db.collection("onboardings")
					.document(documentId)
					.getDocument()
				
				guard
					let data = document.data(),
					let style = data["style"],
					let steps = data["steps"]
				else {
					fatalError("Something is w")
				}
				
				let formattedDocument = [
					"style": style,
					"steps": steps
				]

				let jsonData = try JSONSerialization.data(
					withJSONObject: formattedDocument,
					options: .prettyPrinted
				)
				
				try jsonData.write(to: OnboardingURL)
			}
		)
	}
}
