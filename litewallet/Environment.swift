import UIKit

/// 14  Languages
enum LanguageSelection: Int, CaseIterable, Equatable, Identifiable {
	case English = 0
	case ChineseTraditional
	case ChineseSimplified
	case French
	case German
	case Indonesian
	case Italian
	case Japan
	case Korean
	case Portuguese
	case Russian
	case Spanish
	case Turkish
	case Ukrainian
	var id: LanguageSelection { self }

	var code: String {
		switch self {
		case .English: return "en"
		case .ChineseTraditional: return "zh"
		case .ChineseSimplified: return "zh"
		case .French: return "fr"
		case .German: return "de"
		case .Indonesian: return "id"
		case .Italian: return "it"
		case .Japan: return "ja"
		case .Korean: return "ko"
		case .Portuguese: return "pt"
		case .Russian: return "ru"
		case .Spanish: return "es"
		case .Turkish: return "tr"
		case .Ukrainian: return "uk"
		}
	}

	var nativeName: String {
		switch self {
		case .English: return "English"
		case .ChineseTraditional: return "中國人"
		case .ChineseSimplified: return "中国人"
		case .French: return "Français"
		case .German: return "Deutsch"
		case .Indonesian: return "Bahasa Indonesia"
		case .Italian: return "Italiano"
		case .Japan: return "日本語"
		case .Korean: return "한국인"
		case .Portuguese: return "Português"
		case .Russian: return "Русский"
		case .Spanish: return "Español"
		case .Turkish: return "Türkçe"
		case .Ukrainian: return "українська"
		}
	}

	var voiceFilename: String {
		switch self {
		case .English: return "English"
		case .ChineseTraditional: return "中國人"
		case .ChineseSimplified: return "中國人"
		case .French: return "Français"
		case .German: return "Deutsch"
		case .Indonesian: return "BahasaIndonesia"
		case .Italian: return "Italiano"
		case .Japan: return "日本語"
		case .Korean: return "한국인"
		case .Portuguese: return "Português"
		case .Russian: return "Русский"
		case .Spanish: return "Español"
		case .Turkish: return "Türkçe"
		case .Ukrainian: return "українська"
		}
	}
}

struct E {
	static let isTestnet: Bool = {
		#if Testnet
			return true
		#else
			return false
		#endif
	}()

	static let isTestFlight: Bool = {
		#if Testflight
			return true
		#else
			return false
		#endif
	}()

	static let isSimulator: Bool = {
		#if arch(i386) || arch(x86_64)
			return true
		#else
			return false
		#endif
	}()

	static let isDebug: Bool = {
		#if Debug
			return true
		#else
			return false
		#endif
	}()

	static let isRelease: Bool = {
		#if Release
			return true
		#else
			return false
		#endif
	}()

	static let isScreenshots: Bool = {
		#if Screenshots
			return true
		#else
			return false
		#endif
	}()

	static var isIPhone4: Bool {
		return (UIScreen.main.bounds.size.height == 480.0)
	}

	static var isIPhone5: Bool {
		return (UIScreen.main.bounds.size.height == 568.0) && (E.is32Bit)
	}

	static var isIPhoneX: Bool {
		return (UIScreen.main.bounds.size.height == 812.0)
	}

	static var isIPhone8Plus: Bool {
		return (UIScreen.main.bounds.size.height == 736.0)
	}

	static var isIPhoneXsMax: Bool {
		return (UIScreen.main.bounds.size.height == 812.0)
	}

	static var isIPad: Bool {
		return (UIDevice.current.userInterfaceIdiom == .pad)
	}

	static let is32Bit: Bool = {
		MemoryLayout<Int>.size == MemoryLayout<UInt32>.size
	}()

	static var screenHeight: CGFloat {
		return UIScreen.main.bounds.size.height
	}
}
