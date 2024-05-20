@testable import litewallet
import XCTest

final class LocaleTests: XCTestCase {
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testFilteringUnsupportedCountries() throws {
		/// Based on the live list: https://support.moonpay.com/customers/docs/moonpays_unsupported_countries

		// Afghanistan: `fa_AF`, `ps_AF`, `uz_AF`
		let afghanistanLocale = Locale(identifier: "fa_AF")
		XCTAssertTrue(afghanistanLocale.identifier == "fa_AF")

		// Barbados: `en_BB`
		let barbadosLocale = Locale(identifier: "en_BB")
		XCTAssertTrue(barbadosLocale.identifier == "en_BB")

		// Belarus: `be_BY`, `ru_BY`
		let belarusLocale = Locale(identifier: "be_BY")
		XCTAssertTrue(belarusLocale.identifier == "be_BY")

		// Burkina Faso: `fr_BF`
		let burkinaFasoLocale = Locale(identifier: "fr_BF")
		XCTAssertTrue(burkinaFasoLocale.identifier == "fr_BF")

		// China: `zh_CN`, `zh_Hans_CN`, `zh_Hant_CN`, `ug_CN`
		let chinaLocale = Locale(identifier: "zh_CN")
		XCTAssertTrue(chinaLocale.identifier == "zh_CN")

		// Iceland: `is_IS`
		let icelandLocale = Locale(identifier: "is_IS")
		XCTAssertTrue(icelandLocale.identifier == "is_IS")

		// Iraq: `ar_IQ`, `ku_IQ`
		let iraqLocale = Locale(identifier: "ar_IQ")
		XCTAssertTrue(iraqLocale.identifier == "ar_IQ")

		// Jamaica: `en_JM`, `jam_JM`
		let jamaicaLocale = Locale(identifier: "en_JM")
		XCTAssertTrue(jamaicaLocale.identifier == "en_JM")

		// Japan: `ja_JP`
		let japanLocale = Locale(identifier: "ja_JP")
		XCTAssertTrue(japanLocale.identifier == "ja_JP")

		// Kosovo: `sq_XK`, `sr_XK`
		let kosovoLocale = Locale(identifier: "sq_XK")
		XCTAssertTrue(kosovoLocale.identifier == "sq_XK")

		// Liberia: `en_LR`
		let liberiaLocale = Locale(identifier: "en_LR")
		XCTAssertTrue(liberiaLocale.identifier == "en_LR")

		// Macao: `zh_MO`, `pt_MO`
		let macaoLocale = Locale(identifier: "zh_MO")
		XCTAssertTrue(macaoLocale.identifier == "zh_MO")

		// Malaysia: `ms_MY`, `zh_MY`, `ta_MY`, `en_MY`
		let malaysiaLocale = Locale(identifier: "ms_MY")
		XCTAssertTrue(malaysiaLocale.identifier == "ms_MY")

		// Malta: `mt_MT`, `en_MT`
		let maltaLocale = Locale(identifier: "mt_MT")
		XCTAssertTrue(maltaLocale.identifier == "mt_MT")

		// Mongolia: `mn_MN`
		let mongoliaLocale = Locale(identifier: "mn_MN")
		XCTAssertTrue(mongoliaLocale.identifier == "mn_MN")

		// Morocco: `ar_MA`, `fr_MA`, `ber_MA`
		let moroccoLocale = Locale(identifier: "ar_MA")
		XCTAssertTrue(moroccoLocale.identifier == "ar_MA")

		// Myanmar: `my_MM`
		let myanmarLocale = Locale(identifier: "my_MM")
		XCTAssertTrue(myanmarLocale.identifier == "my_MM")

		// Nicaragua: `es_NI`
		let nicaraguaLocale = Locale(identifier: "es_NI")
		XCTAssertTrue(nicaraguaLocale.identifier == "es_NI")

		// Pakistan: `ur_PK`, `en_PK`
		let pakistanLocale = Locale(identifier: "ur_PK")
		XCTAssertTrue(pakistanLocale.identifier == "ur_PK")

		// Panama: `es_PA`
		let panamaLocale = Locale(identifier: "es_PA")
		XCTAssertTrue(panamaLocale.identifier == "es_PA")

		// Russia: `ru_RU`
		let russiaLocale = Locale(identifier: "ru_RU")
		XCTAssertTrue(russiaLocale.identifier == "ru_RU")

		// Senegal: `fr_SN`, `wo_SN`
		let senegalLocale = Locale(identifier: "fr_SN")
		XCTAssertTrue(senegalLocale.identifier == "fr_SN")

		// The Democratic Republic Of The Congo: `fr_CD`, `ln_CD`, `sw_CD`
		let drCongoLocale = Locale(identifier: "fr_CD")
		XCTAssertTrue(drCongoLocale.identifier == "fr_CD")

		// Uganda: `en_UG`, `sw_UG`
		let ugandaLocale = Locale(identifier: "en_UG")
		XCTAssertTrue(ugandaLocale.identifier == "en_UG")

		// Ukraine: `uk_UA`, `ru_UA`
		let ukraineLocale = Locale(identifier: "uk_UA")
		XCTAssertTrue(ukraineLocale.identifier == "uk_UA")

		// Venezuela: `es_VE`
		let venezuelaLocale = Locale(identifier: "es_VE")
		XCTAssertTrue(venezuelaLocale.identifier == "es_VE")

		// Yemen: `ar_YE`
		let yemenLocale = Locale(identifier: "ar_YE")
		XCTAssertTrue(yemenLocale.identifier == "ar_YE")

		// Zimbabwe: `en_ZW`, `sn_ZW`, `nd_ZW`
		let zimbabweLocale = Locale(identifier: "en_ZW")
		XCTAssertTrue(zimbabweLocale.identifier == "en_ZW")
	}

	func testUnsupportedCountriesEnum() throws {
		let unsupportedCases = UnsupportedCountries.allCases
		XCTAssertTrue(unsupportedCases.count == 28)

		let supportedCountry = Locale(identifier: "en_US").identifier

		for unsupportedLocale in unsupportedCases {
			let unsupportedCode = unsupportedLocale.localeCode
			XCTAssertTrue(unsupportedCode != supportedCountry)
		}
	}
}
