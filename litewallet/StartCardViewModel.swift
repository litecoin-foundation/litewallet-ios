import AVFoundation
import Foundation

class StartCardViewModel: ObservableObject {
	// MARK: - Combine Variables

	// MARK: - Public Variables

	@Published var currentLanguage: LanguageSelection = .English

	@Published var didSelectLanguage: Bool = false

	var staticTagline = ""

	private
	var speechIsPlaying: Bool = false

	private
	let languages: [LanguageSelection] = LanguageSelection.allCases
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

	// MARK: - Private Variables

	private var timer: Timer?

	init() {
		staticTagline = taglines[0]

		cycleThroughLanguages(currentLanguage: currentLanguage)

		startTimer()
	}

	@objc func startTimer() {
		if !didSelectLanguage {
			timer = Timer.scheduledTimer(timeInterval: 2.0,
			                             target: self,
			                             selector: #selector(StartCardViewModel.timerDidFire),
			                             userInfo: nil, repeats: true)
		} else {
			timer?.invalidate()
		}
	}

	@objc private func timerDidFire() {
		updateLanguage()
	}

	private func updateLanguage() {
		if didSelectLanguage {
			timer?.invalidate()
		} else {
			cycleThroughLanguages(currentLanguage: currentLanguage)
		}
	}

	deinit {
		timer?.invalidate()
	}

	func cycleThroughLanguages(currentLanguage _: LanguageSelection) {
		let nextIndex = currentLanguage.rawValue + 1
		if nextIndex == languages.count {
			currentLanguage = LanguageSelection(rawValue: 0)!
		} else {
			currentLanguage = LanguageSelection(rawValue: nextIndex)!
		}
	}

	func speakLanguage(currentLanguage: LanguageSelection) {
		if let url = Bundle.main.url(forResource: currentLanguage.voiceFilename, withExtension: "mp3") {
			var id: SystemSoundID = 0
			AudioServicesCreateSystemSoundID(url as CFURL, &id)
			AudioServicesAddSystemSoundCompletion(id, nil, nil, { soundId, _ in
				AudioServicesDisposeSystemSoundID(soundId)
			}, nil)
			AudioServicesPlaySystemSound(id)
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

//	func showPreferredLangAlert(code: String) {
//		if UserDefaults.selectedLanguage == code { return }
//
//		let alert = Al
//		let alert = UIAlertController(title: nil, message: S.Settings.changeLanguageMessage.localize().replacingOccurrences(of: "%l", with: "\(Locale.current.localizedString(forLanguageCode: code) ?? "") (\(code))"), preferredStyle: .alert)
//		alert.addAction(UIAlertAction(title: S.Fragments.confirm.localize().capitalized, style: .default, handler: { _ in
//			self.viewModel.setLanguage(code: code)
//			self.dismiss(animated: true)
//		}))
//		alert.addAction(UIAlertAction(title: S.Button.cancel.localize(), style: .cancel, handler: nil))
//		present(alert, animated: true, completion: nil)
//	}
}
