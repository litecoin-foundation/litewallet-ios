import Foundation

class LanguageSelectionViewModel {
	var localizations: [String] {
		return Bundle.main.localizations.filter { $0 != "Base" }.sorted()
	}

	func setLanguage(code: String) {
		UserDefaults.selectedLanguage = code
		UserDefaults.standard.synchronize()
		Bundle.setLanguage(code)
		NotificationCenter.default.post(name: .languageChanged, object: nil, userInfo: nil)
	}
}
