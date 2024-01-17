import FirebaseCore
import FirebaseFirestore
import Foundation

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

