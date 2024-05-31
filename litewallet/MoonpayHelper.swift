import Foundation

/// 14  Languages
enum UnsupportedCountries: Int, CaseIterable, Equatable, Identifiable {
	case Afghanistan = 0
	case Barbados
	case Belarus
	case BurkinaFaso
	case China
	case Iceland
	case Iraq
	case Jamaica
	case Japan
	case Kosovo
	case Liberia
	case Macao
	case Malaysia
	case Malta
	case Mongolia
	case Morocco
	case Myanmar
	case Nicaragua
	case Pakistan
	case Panama
	case Russia
	case Senegal
	case DemocraticRepCongo
	case Uganda
	case Ukraine
	case Venezuela
	case Yemen
	case Zimbabwe

	var id: UnsupportedCountries { self }

	var localeCode: String {
		switch self {
		case .Afghanistan: return "fa_AF"
		case .Barbados: return "en_BB"
		case .Belarus: return "be_BY"
		case .BurkinaFaso: return "fr_BF"
		case .China: return "zh_CN"
		case .Iceland: return "is_IS"
		case .Iraq: return "ar_IQ"
		case .Jamaica: return "en_JM"
		case .Japan: return "jp_JP"
		case .Kosovo: return "sq_XK"
		case .Liberia: return "en_LR"
		case .Macao: return "zh_MO"
		case .Malaysia: return "ms_MY"
		case .Malta: return "mt_MT"
		case .Mongolia: return "mn_MN"
		case .Morocco: return "ar_MA"
		case .Myanmar: return "my_MM"
		case .Nicaragua: return "es_NI"
		case .Pakistan: return "ur_PK"
		case .Panama: return "es_PA"
		case .Russia: return "ru_RU"
		case .Senegal: return "fr_SN"
		case .DemocraticRepCongo: return "fr_CD"
		case .Uganda: return "en_UG"
		case .Ukraine: return "uk_UA"
		case .Venezuela: return "es_VE"
		case .Yemen: return "ar_YE"
		case .Zimbabwe: return "en_ZW"
		}
	}
}
