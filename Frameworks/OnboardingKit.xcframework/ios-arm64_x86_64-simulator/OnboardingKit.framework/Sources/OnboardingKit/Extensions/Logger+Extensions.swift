import OSLog

extension Logger {
	static let onboadringKit = Logger(
		subsystem: Bundle.main.bundleIdentifier!,
		category: "OnboadingKit"
	)
}
