import SwiftUI

// TODO: Components
extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (1, 1, 1, 0)
		}
		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue: Double(b) / 255,
			opacity: Double(a) / 255
		)
	}

	var hex: String? {
		// Convert the Color to CGColor
		guard let cgColor = self.cgColor else { return nil }
		
		// Ensure there are 3 components (R, G, B)
		guard cgColor.numberOfComponents == 4 else { return nil }
		
		// Get the components
		let components = cgColor.components!
		
		// Convert to 0-255 scale for R, G and B
		let r = Int(components[0] * 255)
		let g = Int(components[1] * 255)
		let b = Int(components[2] * 255)
		
		// Construct the hex string
		return String(format: "#%02X%02X%02X", r, g, b)
	}
	
	
	func hexToLuminance() -> Double {
		guard var hex = self.hex else {
			return .zero
		}
		if hex.hasPrefix("#") {
			hex = String(hex.dropFirst())
		}
		
		guard let bigint = UInt32(hex, radix: 16) else {
			return 0.0 // or some other default value
		}
		
		let r = Double((bigint >> 16) & 255) / 255.0
		let g = Double((bigint >> 8) & 255) / 255.0
		let b = Double(bigint & 255) / 255.0
		
		let gammaCorrectedR = (r <= 0.03928) ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4)
		let gammaCorrectedG = (g <= 0.03928) ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4)
		let gammaCorrectedB = (b <= 0.03928) ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4)
		
		let luminance = 0.2126 * gammaCorrectedR + 0.7152 * gammaCorrectedG + 0.0722 * gammaCorrectedB
		
		return luminance
	}
	
}
