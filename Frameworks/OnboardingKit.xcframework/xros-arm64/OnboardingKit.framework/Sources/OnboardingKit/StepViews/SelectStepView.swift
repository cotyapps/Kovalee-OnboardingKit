import SwiftUI

struct SelectStepView: View {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle

	let configuration: SelectStep
	@Binding var output: [String: String]
	let continueButtonAction: () -> Void

	@State private var selected: [SelectOption] = []

	private var displayContinueButton: Bool {
		(configuration.multiSelect && !selected.isEmpty) ||
		!configuration.multiSelect && !configuration.directContinue
	}
	
	var body: some View {
		List {
			TitleView(
				title: configuration.title ?? "",
				description: configuration.description,
				properties: output
			)
			.frame(maxWidth: .infinity)
			.listRowBackground(Color.clear)
			
			ForEach(configuration.options) { option in
				SelectButton(
					option: option,
					displayDescriptionOnSelect: configuration.displayDescriptionOnSelect,
					iconSize: CGFloat(configuration.iconSize),
					iconPosition: configuration.iconPosition,
					isSelected: Binding(
						get: {
							$selected.contains(where: { $0.wrappedValue == option })
						},
						set: { _ in }
					),
					action: {
						withAnimation {
							selectOption(option)
						}
					}
				)
				.listRowInsets(
					EdgeInsets(
						top: 5,
						leading: 16,
						bottom: 5,
						trailing: 16
					)
				)
				.listRowSeparator(.hidden)
				.listRowBackground(Color.clear)
			}
		}
		.scrollIndicators(.hidden)
		.listStyle(.plain)
		
		Spacer()
		
		if displayContinueButton {
			BottomView(
				information: configuration.information,
				buttonTitle: configuration.continueButtonTitle,
				properties: output,
				buttonAction: {
					selected.removeAll()
					continueButtonAction()
				}
			)
		}
	}
	
	private func selectOption(_ option: SelectOption) {
		defer {
			if let property = configuration.property, option.reset == nil {
				output[property] = selected.map(\.title).joined(separator: ", ")
			}
		}
		
		guard !(!configuration.multiSelect && configuration.directContinue) else {
			selected.append(option)
			
			Task {
				try? await Task.sleep(for: .seconds(0.5))
				selected.removeAll()
				continueButtonAction()
			}
			return
		}
		
		if selected.contains(option) {
			selected.removeAll(where: { $0 == option })
		} else {
			selected.removeAll(where: { $0.reset != nil })
			
			if !configuration.multiSelect {
				selected.removeAll()
			}
			if option.reset != nil {
				resetSelected(withOption: option)
			} else {
				selected.append(option)
			}
		}
	}
	
	private func resetSelected(withOption option: SelectOption) {
		withAnimation(.linear.delay(0.3)) {
			selected.removeAll()
		}
		withAnimation(.linear.delay(0.5)) {
			selected.append(option)
		}
	}
}

struct SelectButton: View {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle
	
	var option: SelectOption
	var displayDescriptionOnSelect: Bool
	var iconSize: CGFloat
	var iconPosition: IconPosition
	@Binding var isSelected: Bool
	var action: () -> Void
	
	private var displayDescription: Bool {
		option.description != nil &&
		((!displayDescriptionOnSelect) || displayDescriptionOnSelect && isSelected)
	}
	
	private var leftAlignment: Bool {
		style.contentLeftAligned || style.selectOptionsLeftAligned
	}
	
	var body: some View {
		Button(action: action) {
			HStack {
				if iconPosition == .left {
					imageView
				}

				VStack(alignment: .leading) {
					Text(LocalizedStringKey(stringLiteral: option.title))
						.frame(maxWidth: .infinity, alignment: leftAlignment ? .leading : .center)
						.bold()
						.foregroundStyle(style.colorFromLuminance(
							ofColor: isSelected ? style.mainColor : style.secondaryColor
						))
					
					if displayDescription {
						if let description = option.description, !description.isEmpty {
							Text(LocalizedStringKey(stringLiteral: description))
								.multilineTextAlignment(leftAlignment ? .leading : .center)
								.font(.footnote)
								.foregroundStyle(
									style.colorFromLuminance(
										ofColor: isSelected ? style.mainColor : style.secondaryColor
									).opacity(0.7)
								)
						}
					}
				}
				.frame(maxHeight: .infinity, alignment: .top)
				
				if iconPosition == .right {
					imageView
				}
			}
		}
		.buttonStyle(SelectButtonStyle(isSelected: isSelected))
	}
	
	@ViewBuilder
	var imageView: some View {
		if let icon = option.icon {
			if let uiImage = UIImage(named: icon) {
				Image(uiImage: uiImage)
					.renderingMode(.template)
					.resizable()
					.scaledToFit()
					.foregroundColor(
						style.colorFromLuminance(
							ofColor: isSelected ? style.mainColor : style.secondaryColor
						)
					)
					.frame(width: iconSize, height: iconSize)
			} else {
				VStack(spacing: 5) {
					Image(systemName: "photo.artframe")
					Text("Placeholder")
				}
				.foregroundColor(.white)
				.frame(width: iconSize, height: iconSize)
				.background(.gray)
			}
		} else {
			Spacer()
		}
	}
}

struct SelectButtonStyle: ButtonStyle {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle
	
	var isSelected: Bool
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding()
			.frame(maxWidth: .infinity)
			.frame(minHeight: 50)
			.background(
				isSelected ?
				(style.mainColor.opacity(configuration.isPressed ? 0.8 : 1.0)) :
					style.secondaryColor.opacity(configuration.isPressed ? 0.8 : 1.0)
			)
			.cornerRadius(style.buttonCornerRadius)
	}
}

struct SelectStepView_Preview: PreviewProvider {
	static var previews: some View {
		SelectStepView(
			configuration: .mock,
			output: .constant([:]),
			continueButtonAction: {}
		)
		.previewDisplayName("Title")
		
		SelectStepView(
			configuration: .mockSelectDescription,
			output: .constant([:]),
			continueButtonAction: {}
		)
		.previewDisplayName("Title + Description")
		
		SelectStepView(
			configuration: .mockSelectIcon,
			output: .constant([:]),
			continueButtonAction: {}
		)
		
		SelectStepView(
			configuration: .mockSelectIconDescription,
			output: .constant([:]),
			continueButtonAction: {}
		)
	}
}
