import Foundation

class LocaleChangeViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var displayName: String = ""

	init() {
		let currentLocale = Locale.current

		if let regionCode = currentLocale.regionCode,
		   let name = currentLocale.localizedString(forRegionCode: regionCode)
		{
			displayName = name
		} else {
			displayName = "-"
		}
	}
}
