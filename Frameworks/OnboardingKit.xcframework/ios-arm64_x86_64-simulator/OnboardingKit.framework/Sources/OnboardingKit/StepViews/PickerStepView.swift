import SwiftUI

struct PickerStepView: View {
	@Environment(\.onboadingStyle) private var style: OnboardingStyle

	var configuration: PickerStep
	@Binding var output: [String: String]

	let continueButtonAction: () -> Void

	@State private var selectedOption: [String: String] = [:]
	@State private var selectedDate: Date = Date()
	@State private var selectedYear: Int = 0

    var body: some View {
		VStack {
			TitleView(
				title: configuration.title ?? "",
				description: configuration.description,
				properties: output
			)
			Spacer()

			switch configuration.mode {
			case .hour:
				DatePicker(
					"", 
					selection: $selectedDate,
					displayedComponents: .hourAndMinute
				)
				.colorInvert()
				.colorMultiply(style.textColor)
				.labelsHidden()
				.datePickerStyle(.wheel)

			case .date:
				DatePicker(
					"",
					selection: $selectedDate,
					displayedComponents: .date
				)
				.colorInvert()
				.colorMultiply(style.textColor)
				.labelsHidden()
				.datePickerStyle(.wheel)

			case let .year(min, max):
				Picker("", selection: $selectedYear) {
					ForEach(min...max, id: \.self) {
						Text($0, format: .number)
							.font(.custom(style.bodyTextFontName, size: 22))
							.frame(
								maxWidth: .infinity,
								alignment: style.contentLeftAligned ? .leading : .center
							)
							.foregroundColor(style.textColor)
					}
				}
				.pickerStyle(.wheel)

			case .custom(let options):
				HStack {
					ForEach(options, id: \.self) { option in
						Picker("", selection: binding(for: option.property)) {
							ForEach(option.values, id: \.self) { value in
								Text(value)
									.font(.custom(style.bodyTextFontName, size: 22))
									.frame(
										maxWidth: .infinity,
										alignment: style.contentLeftAligned ? .leading : .center
									)
									.foregroundColor(style.textColor)
							}
						}
					}
				}
				.pickerStyle(.wheel)
			}

			Spacer()
			BottomView(
				information: configuration.information,
				buttonTitle: configuration.continueButtonTitle,
				properties: output,
				buttonAction: {
					defer {
						continueButtonAction()
					}

					guard let property = configuration.property else {
						return
					}

					switch configuration.mode {
					case .custom:
						selectedOption.forEach { output[$0.key] = $0.value }
					case .date, .hour:
						output[property] = selectedDate.formatted()
					case .year:
						output[property] = "\(selectedYear)"
					}
				}
			)
		}
		.onAppear {
			switch configuration.mode {
			case .year(let min, let max):
				selectedYear = (max + min) / 2
			case .custom(let options):
				options.forEach {
					selectedOption[$0.property] = $0.defaultValue ?? $0.values.first ?? ""
				}
			default: ()
			}
		}
    }
	
	// provides a binding to a dictionary
	private func binding(for property: String) -> Binding<String> {
		Binding<String>(
			get: { selectedOption[property] ?? "" },
			set: { selectedOption[property] = $0 }
		)
	}
}

struct PickerStepView_Preview: PreviewProvider {
	static var previews: some View {
		PickerStepView(
			configuration: .mock,
			output: .constant([:]),
			continueButtonAction: {}
		)
		.padding(20)
		.previewDisplayName("Custom")
		
		PickerStepView(
			configuration: .mockHour,
			output: .constant([:]),
			continueButtonAction: {}
		)
		.padding(20)
		.previewDisplayName("Time")
		
		PickerStepView(
			configuration: .mockDate,
			output: .constant([:]),
			continueButtonAction: {}
		)
		.padding(20)
		.previewDisplayName("Date")
		
		PickerStepView(
			configuration: .mockYear,
			output: .constant([:]),
			continueButtonAction: {}
		)
		.padding(20)
		.previewDisplayName("Year")
	}
}
