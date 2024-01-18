import CodeScanner
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
	@State private var showQRScanner: Bool = false

	private let onboardingHandler = OnboardingHandler.live
	
	@AppStorage("documentId") private var documentId: String = ""
	@AppStorage("onboardingName") private var onbName: String = ""

	private var onDismiss: () -> Void
	
	public init(documentId: String, onDismiss: @escaping () -> Void) {
		self.onDismiss = onDismiss
		self.documentId = documentId
	}
	
	public init(onDismiss: @escaping () -> Void) {
		self.onDismiss = onDismiss
	}
	
	public var body: some View {
		VStack {
			switch state {
			case .none:
				VStack(spacing: 10) {
					HStack {
						Spacer()
						Button(
							action: onDismiss,
							label: {
								Image(systemName: "xmark")
							}
						)
						.buttonStyle(.bordered)
						.padding(20)
					}

					Spacer()
					if !onbName.isEmpty {
						VStack {
							Text("Current Onboarding:")
							Text(onbName)
								.font(.title2).bold()
						}
						.padding(.bottom, 10)
					}
					HStack(spacing: 20) {
						Button {
							showQRScanner = true
						} label: {
							Image(systemName: "qrcode")
						}
						.buttonStyle(.bordered)

						if !documentId.isEmpty {
							Button(
								action: retrieveOnboarding,
								label: {
									Image(systemName: "arrow.clockwise")
								}
							)
							.buttonStyle(.bordered)
						}
					}
					Spacer()
				}
				.frame(maxHeight: .infinity)

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
		.fullScreenCover(isPresented: $showQRScanner) {
			CodeScannerView(
				codeTypes: [.qr]
			) { result in
				switch result {
				case .success(let result):
					self.documentId = result.string
					self.retrieveOnboarding()
				case .failure(let error):
					state = .error(error.localizedDescription)
				}

				showQRScanner = false
			}
			.background(.black).edgesIgnoringSafeArea(.all)
		}
	}
	
	private func retrieveOnboarding() {
		Task {
			state = .loading
			do {
				self.onbName = try await onboardingHandler.retrieveOnboardingWithDocumentId(self.documentId) ?? ""
				let configuration = try Configuration.loadFromURL(OnboardingURL)
				state = .ready(configuration)
			} catch {
				state = .error(error.localizedDescription)
			}
		}
	}
}

#Preview {
	OnboardingDevModeView(documentId: "") {
		
	}
}
