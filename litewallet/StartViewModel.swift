import AVFoundation
import Foundation
import SwiftUI
import UIKit

class StartViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var currentLanguage: LanguageSelection = .English

	@Published
	var tappedIndex: Int = 0

	@Published
	var walletCreationDidFail: Bool = false

	@Published
	var seedWords: [SeedWord] = [SeedWord(word: "indicate"), SeedWord(word: "material"), SeedWord(word: "property"),
	                             SeedWord(word: "banana"), SeedWord(word: "tuition"), SeedWord(word: "lemon"),
	                             SeedWord(word: "banana"), SeedWord(word: "tuition"), SeedWord(word: "lemon"),
	                             SeedWord(word: "banana"), SeedWord(word: "tuition"), SeedWord(word: "surround")]

	@Published
	var pinDigits = ""

	@Published
	var pinIsFilled = false

	@Published
	var pinViewRect = CGRect()

	@Published
	var headerTitle = S.CreateStep.MainTitle.intro.localize()

	// MARK: - Public Variables

	var staticTagline = ""
	var didTapCreate: (() -> Void)?
	var didTapRecover: (() -> Void)?
	var store: Store
	var walletManager: WalletManager

	let languages: [LanguageSelection] = LanguageSelection.allCases

	init(store: Store, walletManager: WalletManager) {
		self.store = store
		self.walletManager = walletManager
		staticTagline = taglines[0]

		// loadResourcesWithTag(tags: audioTagArray)

		// checkForWalletAndSync()
	}

	/// Completion Handler process
	///  1. Create a closure var
	///  2. Create an func with an escaping closure and the signature should match the one in step 1
	///  3. In the func make the var equal it to func signature
	///  4. The parent calls the func of this class
	///  5. The third class that is observing the class with the function  triggers the var

	func userWantsToCreate(completion: @escaping () -> Void) {
		didTapCreate = completion
	}

	func userWantsToRecover(completion: @escaping () -> Void) {
		didTapRecover = completion
	}

	private func checkForWalletAndSync() {
		/// Test seed count
		guard seedWords.count == 12 else { return }

		/// Set for default.  This model needs a initial value
		walletManager.forceSetPin(newPin: Partner.partnerKeyPath(name: .litewalletStart))

		guard walletManager.setRandomSeedPhrase() != nil else {
			walletCreationDidFail = true
			let properties: [String: String] = ["ERROR_MESSAGE": "wallet_creation_fail"]
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
			return
		}

		store.perform(action: WalletChange.setWalletCreationDate(Date()))
		DispatchQueue.walletQueue.async {
			self.walletManager.peerManager?.connect()
			DispatchQueue.main.async {
				self.store.trigger(name: .didCreateOrRecoverWallet)
			}
		}
	}

	func updateHeader() {
		switch tappedIndex {
		case 0:
			headerTitle = S.CreateStep.MainTitle.intro.localize()
		case 1:
			headerTitle = S.CreateStep.MainTitle.checkboxes.localize()
		case 2:
			headerTitle = S.CreateStep.MainTitle.seedPhrase.localize()
		case 3:
			headerTitle = S.CreateStep.MainTitle.finished.localize()
		default:
			headerTitle = S.CreateStep.MainTitle.intro.localize()
		}
	}

	func speakLanguage() {
		if let url = Bundle.main.url(forResource: currentLanguage.voiceFilename, withExtension: "mp3") {
			var id: SystemSoundID = 0
			AudioServicesCreateSystemSoundID(url as CFURL, &id)
			AudioServicesAddSystemSoundCompletion(id, nil, nil, { soundId, _ in
				AudioServicesDisposeSystemSoundID(soundId)
			}, nil)
			AudioServicesPlaySystemSound(id)
		} else {
			print("NO AUDIO")
		}
	}

	func setLanguage(code: String) {
		UserDefaults.selectedLanguage = code
		UserDefaults.standard.synchronize()
		Bundle.setLanguage(code)

		DispatchQueue.main.async {
			NotificationCenter.default.post(name: .languageChangedNotification,
			                                object: nil,
			                                userInfo: nil)
		}
	}

	func generateNewSeedPhrase() -> [String] {
		return [""]
	}

	// MARK: - Lengthy elements

	///  Set these to the bottom to make the others more readable
	///   These are semi-hardcoded because the state is in flux
	let taglines: [String] = [
		"The most secure and easiest way to use Litecoin.",
		"使用莱特币最安全、最简单的方式。",
		"使用莱特币最安全、最简单的方式",
		"La manière la plus sûre et la plus simple d'utiliser Litecoin.",
		"Die sicherste Option zur Nutzung von Litecoin.",
		"Cara paling aman dan termudah untuk menggunakan Litecoin.",
		"Il modo più sicuro e semplice per utilizzare Litecoin.",
		"最も安全にリテコインを使う手段。",
		"라이트코인을 사용하는 가장 안전하고 쉬운 방법입니다.",
		"A maneira mais segura e fácil de usar Litecoin.",
		"Самый безопасный и простой способ использовать Litecoin",
		"La forma más segura y sencilla de utilizar Litecoin",
		"Litecoin kullanmanın en güvenli ve en kolay yolu.",
		"Найбезпечніший і найпростіший спосіб використання Litecoin",
	]

	let alertMessage: [String] = [
		"Are you sure you want to change the language to English?",
		"您确定要更改语言吗?",
		"您確定要更改語言嗎？",
		"Voulez-vous vraiment changer la langue?",
		"Sind Sie sicher, dass Sie die Sprache auf Deutsch ändern möchten?",
		"Yakin ingin mengubah bahasanya ke bahasa Indonesia?",
		"Sei sicuro di voler cambiare la lingua in italiano?",
		"言語を日本語に変更してもよろしいですか?",
		"언어를 한국어로 변경하시겠습니까?",
		"Tem certeza de que deseja alterar o idioma para português?",
		"Вы уверены, что хотите сменить язык на русский?",
		"¿Estás seguro de que quieres cambiar el idioma a español?",
		"Dili Türkçe olarak değiştirmek istediğinizden emin misiniz?",
		"Ви впевнені, що хочете змінити мову на українську?",
	]

	let yesLabel: [String] = [
		"Yes",
		"是的",
		"是的",
		"Oui",
		"Ja",
		"Ya",
		"SÌ",
		"はい",
		"예",
		"Sim",
		"Да",
		"Sí",
		"Evet",
		"Так",
	]

	let cancelLabel: [String] = [
		"Cancel",
		"取消",
		"取消",
		"Annuler",
		"Stornieren",
		"Membatalkan",
		"Annulla",
		"キャンセル",
		"취소",
		"Cancelar",
		"Отмена",
		"Cancelar",
		"İptal etmek",
		"Скасувати",
	]

	func stringToCurrentLanguage(languageString: String) -> LanguageSelection {
		switch languageString {
		case "English":
			return LanguageSelection(rawValue: 0)!
		case "中國人":
			return LanguageSelection(rawValue: 1)!
		case "中国人":
			return LanguageSelection(rawValue: 2)!
		case "Français":
			return LanguageSelection(rawValue: 3)!
		case "Deutsch":
			return LanguageSelection(rawValue: 4)!
		case "Bahasa Indonesia":
			return LanguageSelection(rawValue: 5)!
		case "Italiano":
			return LanguageSelection(rawValue: 6)!
		case "日本語":
			return LanguageSelection(rawValue: 7)!
		case "한국인":
			return LanguageSelection(rawValue: 8)!
		case "Português":
			return LanguageSelection(rawValue: 9)!
		case "Русский":
			return LanguageSelection(rawValue: 10)!
		case "Español":
			return LanguageSelection(rawValue: 11)!
		case "Türkçe":
			return LanguageSelection(rawValue: 12)!
		case "українська":
			return LanguageSelection(rawValue: 13)!
		default:
			return LanguageSelection(rawValue: 0)!
		}
	}
}
