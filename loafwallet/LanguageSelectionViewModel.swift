import Foundation

class LanguageSelectionViewModel {
	var bundle: Bundle

	init(bundle: Bundle) {
		self.bundle = bundle
		print("::: bundlKSM.bundlePath : \(self.bundle.bundlePath)")
	}

	var localizations: [String] {
		return ["Base"] // Bundle.main.localizations.filter { $0 != "Base" }.sorted()
	}

	func setLanguage(code: String) {
		UserDefaults.selectedLanguage = code
		UserDefaults.standard.synchronize()
		Bundle.setLanguage(code)
		NotificationCenter.default.post(name: .languageChanged, object: nil, userInfo: nil)
	}
}
