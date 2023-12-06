import Foundation

enum S {
	enum Symbols {
		static let photons = "mł"
		static let lites = "ł"
		static let ltc = "Ł"
		static let narrowSpace = "\u{2009}"
		static let lock = "\u{1F512}"
		static let redX = "\u{274C}"
		static func currencyButtonTitle(maxDigits: Int) -> String {
			switch maxDigits {
			case 2:
				return "photons\(S.Symbols.narrowSpace)(m\(S.Symbols.lites))"
			case 5:
				return "lites\(S.Symbols.narrowSpace)(\(S.Symbols.lites))"
			case 8:
				return "LTC\(S.Symbols.narrowSpace)(\(S.Symbols.ltc))"
			default:
				return "lites\(S.Symbols.narrowSpace)(\(S.Symbols.lites))"
			}
		}
	}

	enum Conjuction {
		static let asOf = Localization(key: "Conjunction.asOf", value: "as of", comment: "as of a time or date")
	}

	// MARK: - Generic Button labels

	enum Button {
		static let ok = Localization(key: "Button.ok", value: "OK", comment: "OK button label")
		static let cancel = Localization(key: "Button.cancel", value: "Cancel", comment: "Cancel button label")
		static let settings = Localization(key: "Button.settings", value: "Settings", comment: "Settings button label")
		static let submit = Localization(key: "Button.submit", value: "Submit", comment: "Settings button label")
		static let ignore = Localization(key: "Button.ignore", value: "Ignore", comment: "Ignore button label")
		static let yes = Localization(key: "Button.yes", value: "Yes", comment: "Yes button")
		static let no = Localization(key: "Button.no", value: "No", comment: "No button")
		static let send = Localization(key: "Button.send", value: "send", comment: "send button")
		static let receive = Localization(key: "Button.receive", value: "receive", comment: "receive button")
		static let menu = Localization(key: "Button.menu", value: "menu", comment: "menu button")
		static let buy = Localization(key: "Button.buy", value: "buy", comment: "buy button")
		static let resetFields = Localization(key: "Button.resetFields", value: "reset", comment: "resetFields")
	}

	enum LitewalletAlert {
		static let warning = Localization(key: "Alert.warning", value: "Warning", comment: "Warning alert title")
		static let error = Localization(key: "Alert.error", value: "Error", comment: "Error alert title")
		static let noInternet = Localization(key: "Alert.noInternet", value: "No internet connection found. Check your connection and try again.", comment: "No internet alert message")
		static let corruptionError = Localization(key: "Alert.corruptionError", value: "Database Corruption Error", comment: "Corruption Error alert title")
		static let corruptionMessage = Localization(key: "Alert.corruptionMessage", value: "Your local database is corrupted. Go to Settings > Blockchain: Settings > Delete Database to refresh", comment: "Corruption Error alert title")
	}

	enum Scanner {
		static let flashButtonLabel = Localization(key: "Scanner.flashButtonLabel", value: "Camera Flash", comment: "Scan Litecoin address camera flash toggle")
	}

	enum Send {
		static let title = Localization(key: "Send.title", value: "Send", comment: "Send modal title")
		static let toLabel = Localization(key: "Send.toLabel", value: "To", comment: "Send money to label")
		static let enterLTCAddressLabel = Localization(key: "Send.enterLTCAddress", value: "Enter LTC Address", comment: "Enter LTC Address")
		static let amountLabel = Localization(key: "Send.amountLabel", value: "Amount", comment: "Send money amount label")
		static let descriptionLabel = Localization(key: "Send.descriptionLabel", value: "Memo", comment: "Description for sending money label")
		static let sendLabel = Localization(key: "Send.sendLabel", value: "Send", comment: "Send button label")
		static let pasteLabel = Localization(key: "Send.pasteLabel", value: "Paste", comment: "Paste button label")
		static let scanLabel = Localization(key: "Send.scanLabel", value: "Scan", comment: "Scan button label")
		static let invalidAddressTitle = Localization(key: "Send.invalidAddressTitle", value: "Invalid Address", comment: "Invalid address alert title")
		static let invalidAddressMessage = Localization(key: "Send.invalidAddressMessage", value: "The destination address is not a valid Litecoin address.", comment: "Invalid address alert message")
		static let invalidAddressOnPasteboard = Localization(key: "Send.invalidAddressOnPasteboard", value: "Pasteboard does not contain a valid Litecoin address.", comment: "Invalid address on pasteboard message")
		static let emptyPasteboard = Localization(key: "Send.emptyPasteboard", value: "Pasteboard is empty", comment: "Empty pasteboard error message")
		static let cameraUnavailableTitle = Localization(key: "Send.cameraUnavailableTitle", value: "Litewallet is not allowed to access the camera", comment: "Camera not allowed alert title")
		static let cameraUnavailableMessage = Localization(key: "Send.cameraunavailableMessage", value: "Go to Settings to allow camera access.", comment: "Camera not allowed message")
		static let balance = Localization(key: "Send.balance", value: "Balance: %1$@", comment: "Balance: $4.00")
		static let fee = Localization(key: "Send.fees", value: "Fees: %1$@", comment: "Fees: $0.10")
		static let feeBlank = Localization(key: "Send.feeBlank", value: "Fees:", comment: "Fees: ")
		static let bareFee = Localization(key: "Send.fee", value: "Fee: %1$@", comment: "Fee: $0.01")
		static let containsAddress = Localization(key: "Send.containsAddress", value: "The destination is your own address. You cannot send to yourself.", comment: "Warning when sending to self.")
		enum UsedAddress {
			static let title = Localization(key: "Send.UsedAddress.title", value: "Address Already Used", comment: "Adress already used alert title")
			static let firstLine = Localization(key: "Send.UsedAddress.firstLine", value: "Litecoin addresses are intended for single use only.", comment: "Adress already used alert message - first part")
			static let secondLine = Localization(key: "Send.UsedAddress.secondLIne", value: "Re-use reduces privacy for both you and the recipient and can result in loss if the recipient doesn't directly control the address.", comment: "Adress already used alert message - second part")
		}

		static let identityNotCertified = Localization(key: "Send.identityNotCertified", value: "Payee identity isn't certified.", comment: "Payee identity not certified alert title.")
		static let createTransactionError = Localization(key: "Send.creatTransactionError", value: "Could not create transaction.", comment: "Could not create transaction alert title")
		static let publicTransactionError = Localization(key: "Send.publishTransactionError", value: "Could not publish transaction.", comment: "Could not publish transaction alert title")
		static let noAddress = Localization(key: "Send.noAddress", value: "Please enter the recipient's address.", comment: "Empty address alert message")
		static let noAmount = Localization(key: "Send.noAmount", value: "Please enter an amount to send.", comment: "Emtpy amount alert message")
		static let isRescanning = Localization(key: "Send.isRescanning", value: "Sending is disabled during a full rescan.", comment: "Is rescanning error message")
		static let remoteRequestError = Localization(key: "Send.remoteRequestError", value: "Could not load payment request", comment: "Could not load remote request error message")
		static let loadingRequest = Localization(key: "Send.loadingRequest", value: "Loading Request", comment: "Loading request activity view message")
		static let insufficientFunds = Localization(key: "Send.insufficientFunds", value: "Insufficient Funds", comment: "Insufficient funds error")
		static let barItemTitle = Localization(key: "Send.barItemTitle", value: "Send", comment: "Send Bar Item Title")

		enum UnstoppableDomains {
			static let placeholder = Localization(key: "Send.UnstoppableDomains.placeholder", value: "Enter a .crypto or .zil domain", comment: "Enter a .crypto,.zil domain")
			static let simplePlaceholder = Localization(key: "Send.UnstoppableDomains.simpleplaceholder", value: "Enter domain", comment: "Enter domain")
			static let enterA = Localization(key: "Send.UnstoppableDomains.enterA", value: "Enter a", comment: "Enter a")
			static let domain = Localization(key: "Send.UnstoppableDomains.domain", value: "domain", comment: "domain")
			static let lookup = Localization(key: "Send.UnstoppableDomains.lookup", value: "Lookup", comment: "Lookup")
			static let lookupFailureHeader = Localization(key: "Send.UnstoppableDomains.lookupFailureHeader", value: "LookupFailureHeader", comment: "lookupFailureHeader")
			static let lookupDomainError = Localization(key: "Send.UnstoppableDomains.lookupDomainError", value: "LookupDomainError", comment: "LookupDomainError")
			static let udSystemError = Localization(key: "Send.UnstoppableDomains.udSystemError", value: "UDSystemError", comment: "UDSystemError")
		}
	}

	enum Receive {
		static let title = Localization(key: "Receive.title", value: "Receive", comment: "Receive modal title")
		static let emailButton = Localization(key: "Receive.emailButton", value: "Email", comment: "Share via email button label")
		static let textButton = Localization(key: "Receive.textButton", value: "Text Message", comment: "Share via text message (SMS)")
		static let copied = Localization(key: "Receive.copied", value: "Copied to clipboard.", comment: "Address copied message.")
		static let share = Localization(key: "Receive.share", value: "Share", comment: "Share button label")
		static let request = Localization(key: "Receive.request", value: "Request an Amount", comment: "Request button label")
		static let barItemTitle = Localization(key: "Receive.barItemTitle", value: "Receive", comment: "Receive Bar Item Title")
	}

	// MARK: - Litewallet

	enum Litewallet {
		static let name = Localization(key: "Litewallet.name", value: "Litewallet", comment: "Litewallet name")
	}

	enum Account {
		static let loadingMessage = Localization(key: "Account.loadingMessage", value: "Loading Wallet", comment: "Loading Wallet Message")
	}

	enum History {
		static let barItemTitle = Localization(key: "History.barItemTitle", value: "History", comment: "History Bar Item Title")
		static let currentLitecoinValue = Localization(key: "History.currentLitecoinValue", value: "History CurrentLitecoinValue", comment: "History Current Litecoin Value")
	}

	enum JailbreakWarnings {
		static let title = Localization(key: "JailbreakWarnings.title", value: "WARNING", comment: "Jailbreak warning title")
		static let messageWithBalance = Localization(key: "JailbreakWarnings.messageWithBalance", value: "DEVICE SECURITY COMPROMISED\n Any 'jailbreak' app can access Litewallet's keychain data and steal your Litecoin! Wipe this wallet immediately and restore on a secure device.", comment: "Jailbreak warning message")
		static let messageWithoutBalance = Localization(key: "JailbreakWarnings.messageWithoutBalance", value: "DEVICE SECURITY COMPROMISED\n Any 'jailbreak' app can access Litewallet's keychain data and steal your Litecoin. Please only use Litewallet on a non-jailbroken device.", comment: "Jailbreak warning message")
		static let ignore = Localization(key: "JailbreakWarnings.ignore", value: "Ignore", comment: "Ignore jailbreak warning button")
		static let wipe = Localization(key: "JailbreakWarnings.wipe", value: "Wipe", comment: "Wipe wallet button")
		static let close = Localization(key: "JailbreakWarnings.close", value: "Close", comment: "Close app button")
	}

	enum ErrorMessages {
		static let emailUnavailableTitle = Localization(key: "ErrorMessages.emailUnavailableTitle", value: "Email Unavailable", comment: "Email unavailable alert title")
		static let emailUnavailableMessage = Localization(key: "ErrorMessages.emailUnavailableMessage", value: "This device isn't configured to send email with the iOS mail app.", comment: "Email unavailable alert title")
		static let messagingUnavailableTitle = Localization(key: "ErrorMessages.messagingUnavailableTitle", value: "Messaging Unavailable", comment: "Messaging unavailable alert title")
		static let messagingUnavailableMessage = Localization(key: "ErrorMessages.messagingUnavailableMessage", value: "This device isn't configured to send messages.", comment: "Messaging unavailable alert title")
	}

	enum UnlockScreen {
		static let myAddress = Localization(key: "UnlockScreen.myAddress", value: "My Address", comment: "My Address button title")
		static let scan = Localization(key: "UnlockScreen.scan", value: "Scan", comment: "Scan button title")
		static let touchIdText = Localization(key: "UnlockScreen.touchIdText", value: "Unlock with TouchID", comment: "Unlock with TouchID accessibility label")
		static let touchIdPrompt = Localization(key: "UnlockScreen.touchIdPrompt", value: "Unlock your Litewallet.", comment: "TouchID/FaceID prompt text")
		static let enterPIN = Localization(key: "UnlockScreen.enterPin", value: "Enter PIN", comment: "Unlock Screen sub-header")
		static let unlocked = Localization(key: "UnlockScreen.unlocked", value: "Wallet Unlocked", comment: "Wallet unlocked message")
		static let disabled = Localization(key: "UnlockScreen.disabled", value: "Disabled until: %1$@", comment: "Disabled until date")
		static let resetPin = Localization(key: "UnlockScreen.resetPin", value: "Reset PIN", comment: "Reset PIN with Paper Key button label.")
		static let faceIdText = Localization(key: "UnlockScreen.faceIdText", value: "Unlock with FaceID", comment: "Unlock with FaceID accessibility label")
	}

	enum Transaction {
		static let justNow = Localization(key: "Transaction.justNow", value: "just now", comment: "Timestamp label for event that just happened")
		static let invalid = Localization(key: "Transaction.invalid", value: "INVALID", comment: "Invalid transaction")
		static let complete = Localization(key: "Transaction.complete", value: "Complete", comment: "Transaction complete label")
		static let waiting = Localization(key: "Transaction.waiting", value: "Waiting to be confirmed. Some merchants require confirmation to complete a transaction. Estimated time: 1-2 hours.", comment: "Waiting to be confirmed string")
		static let starting = Localization(key: "Transaction.starting", value: "Starting balance: %1$@", comment: "eg. Starting balance: $50.00")
		static let fee = Localization(key: "Transaction.fee", value: "(%1$@ fee)", comment: "(b600 fee)")
		static let ending = Localization(key: "Transaction.ending", value: "Ending balance: %1$@", comment: "eg. Ending balance: $50.00")
		static let exchangeOnDaySent = Localization(key: "Transaction.exchangeOnDaySent", value: "Exchange rate when sent:", comment: "Exchange rate on date header")
		static let exchangeOnDayReceived = Localization(key: "Transaction.exchangeOnDayReceived", value: "Exchange rate when received:", comment: "Exchange rate on date header")
		static let receivedStatus = Localization(key: "Transaction.receivedStatus", value: "In progress: %1$@", comment: "Receive status text: 'In progress: 20%'")
		static let sendingStatus = Localization(key: "Transaction.sendingStatus", value: "In progress: %1$@", comment: "Send status text: 'In progress: 20%'")
		static let available = Localization(key: "Transaction.available", value: "Available to Spend", comment: "Availability status text")
		static let txIDLabel = Localization(key: "Transaction.txIDLabel", value: "Transaction txID", comment: "Static TX iD Label")
		static let amountDetailLabel = Localization(key: "Transaction.amountDetailLabel", value: "Transaction amount detail", comment: "Static amount Label")
		static let startingAmountDetailLabel = Localization(key: "Transaction.startingAmountDetailLabel", value: "Transaction starting amount detail", comment: "Static starting amount Label")
		static let endAmountDetailLabel = Localization(key: "Transaction.endAmountDetailLabel", value: "Transaction end amount detail", comment: "Static end amount Label")
		static let blockHeightLabel = Localization(key: "Transaction.blockHeightLabel", value: "Transaction blockHeightLabel", comment: "Static blockHeight Label")
		static let commentLabel = Localization(key: "Transaction.commentLabel", value: "Transaction comment label", comment: "Static comment Label")
	}

	enum TransactionDetails {
		static let title = Localization(key: "TransactionDetails.title", value: "Transaction Details", comment: "Transaction Details Title")
		static let receiveModaltitle = Localization(key: "TransactionDetails.receivedModalTitle", value: "RECEIVE LTC", comment: "RECEIVE LTCTitle")
		static let statusHeader = Localization(key: "TransactionDetails.statusHeader", value: "Status", comment: "Status section header")
		static let commentsHeader = Localization(key: "TransactionDetails.commentsHeader", value: "Memo", comment: "Memo section header")
		static let amountHeader = Localization(key: "TransactionDetails.amountHeader", value: "Amount", comment: "Amount section header")
		static let emptyMessage = Localization(key: "TransactionDetails.emptyMessage", value: "Your transactions will appear here.", comment: "Empty transaction list message.")
		static let txHashHeader = Localization(key: "TransactionDetails.txHashHeader", value: "Litecoin Transaction ID", comment: "Transaction ID header")
		static let sentAmountDescription = Localization(key: "TransactionDetails.sentAmountDescription", value: "Sent <b>%1@</b>", comment: "Sent $5.00")
		static let receivedAmountDescription = Localization(key: "TransactionDetails.receivedAmountDescription", value: "Received <b>%1@</b>", comment: "Received $5.00")
		static let movedAmountDescription = Localization(key: "TransactionDetails.movedAmountDescription", value: "Moved <b>%1@</b>", comment: "Moved $5.00")
		static let account = Localization(key: "TransactionDetails.account", value: "account", comment: "e.g. I received money from an account.")
		static let sent = Localization(key: "TransactionDetails.sent", value: "Sent %1$@", comment: "Sent $5.00 (sent title 1/2)")
		static let received = Localization(key: "TransactionDetails.received", value: "Received %1$@", comment: "Received $5.00 (received title 1/2)")
		static let moved = Localization(key: "TransactionDetails.moved", value: "Moved %1$@", comment: "Moved $5.00")
		static let to = Localization(key: "TransactionDetails.to", value: "to %1$@", comment: "[sent] to <address> (sent title 2/2)")
		static let from = Localization(key: "TransactionDetails.from", value: "at %1$@", comment: "[received] at <address> (received title 2/2)")
		static let blockHeightLabel = Localization(key: "TransactionDetails.blockHeightLabel", value: "Confirmed in Block", comment: "Block height label")
		static let notConfirmedBlockHeightLabel = Localization(key: "TransactionDetails.notConfirmedBlockHeightLabel", value: "Not Confirmed", comment: "eg. Confirmed in Block: Not Confirmed")
		static let staticTXIDLabel = Localization(key: "TransactionDetails.staticTXLabel", value: "TXID:", comment: "Label for TXID")
		static let priceTimeStampLabel = Localization(key: "TransactionDetails.priceTimeStampPrefix", value: "as of", comment: "Prefix for price")
		static let copyAllDetails = Localization(key: "TransactionDetails.copyAllDetails", value: "Copy all details", comment: "Copy all details")
		static let copiedAll = Localization(key: "TransactionDetails.copiedAll", value: "Copied", comment: "Copied")
	}

	// MARK: - Buy Center

	enum BuyCenter {
		static let title = Localization(key: "BuyCenter.title", value: "Buy Litecoin", comment: "Buy Center Title")
		static let buyModalTitle = Localization(key: "BuyCenter.ModalTitle", value: "Buy Łitecoin", comment: "Buy Modal Title")
		enum Cells {
			static let moonpayTitle = Localization(key: "BuyCenter.moonpayTitle", value: "Moonpay", comment: "Moonpay Title")
			static let moonpayFinancialDetails = Localization(key: "BuyCenter.moonpayFinancialDetails", value: "• Point 1 XXXXX\n• Point 2 XXXXn• XXX Point 3", comment: "Moonpay buy financial details")
			static let simplexTitle = Localization(key: "BuyCenter.simplexTitle", value: "Simplex", comment: "Simplex Title")
			static let simplexFinancialDetails = Localization(key: "BuyCenter.simplexFinancialDetails", value: "• Get Litecoin in 5 mins!\n• Buy Litecoin via credit card\n• Passport or State ID", comment: "Simplex buy financial details")
			static let changellyTitle = Localization(key: "BuyCenter.changellyTitle", value: "Changelly", comment: "Changelly Title")
			static let changellyFinancialDetails = Localization(key: "BuyCenter.changellyFinancialDetails", value: "• Change Litecoin for other cryptos\n• No ID Required\n• Buy via credit card\n• Global coverage", comment: "Changelly buy financial details")
			static let bitrefillTitle = Localization(key: "BuyCenter.BitrefillTitle", value: "Bitrefill", comment: "Bitrefill Title")
			static let bitrefillFinancialDetails = Localization(key: "BuyCenter.bitrefillFinancialDetails", value: "• Buy gift cards\n• Refill prepaid phones\n• Steam, Amazon, Hotels.com\n• Works in 170 countries", comment: "Bitrefill buy financial details")
		}

		static let barItemTitle = Localization(key: "BuyCenter.barItemTitle", value: "Buy", comment: "Buy Bar Item Title")
	}

	// MARK: - Security Center

	enum SecurityCenter {
		static let title = Localization(key: "SecurityCenter.title", value: "Security Center", comment: "Security Center Title")
		static let info = Localization(key: "SecurityCenter.info", value: "Enable all security features for maximum protection.", comment: "Security Center Info")
		enum Cells {
			static let pinTitle = Localization(key: "SecurityCenter.pinTitle", value: "6-Digit PIN", comment: "PIN button title")
			static let pinDescription = Localization(key: "SecurityCenter.pinDescription", value: "Protects your Litewallet from unauthorized users.", comment: "PIN button description")
			static let touchIdTitle = Localization(key: "SecurityCenter.touchIdTitle", value: "Touch ID", comment: "Touch ID button title")
			static let touchIdDescription = Localization(key: "SecurityCenter.touchIdDescription", value: "Conveniently unlock your Litewallet and send money up to a set limit.", comment: "Touch ID/FaceID button description")
			static let paperKeyTitle = Localization(key: "SecurityCenter.paperKeyTitle", value: "Paper Key", comment: "Paper Key button title")
			static let paperKeyDescription = Localization(key: "SecurityCenter.paperKeyDescription", value: "The only way to access your Litecoin if you lose or upgrade your phone.", comment: "Paper Key button description")
			static let faceIdTitle = Localization(key: "SecurityCenter.faceIdTitle", value: "Face ID", comment: "Face ID button title")
		}
	}

	enum UpdatePin {
		static let updateTitle = Localization(key: "UpdatePin.updateTitle", value: "Update PIN", comment: "Update PIN title")
		static let createTitle = Localization(key: "UpdatePin.createTitle", value: "Set PIN", comment: "Update PIN title")
		static let createTitleConfirm = Localization(key: "UpdatePin.createTitleConfirm", value: "Re-Enter PIN", comment: "Update PIN title")
		static let createInstruction = Localization(key: "UpdatePin.createInstruction", value: "Your PIN will be used to unlock your Litewallet and send money.", comment: "PIN creation info.")
		static let enterCurrent = Localization(key: "UpdatePin.enterCurrent", value: "Enter your current PIN.", comment: "Enter current PIN instruction")
		static let enterNew = Localization(key: "UpdatePin.enterNew", value: "Enter your new PIN.", comment: "Enter new PIN instruction")
		static let reEnterNew = Localization(key: "UpdatePin.reEnterNew", value: "Re-Enter your new PIN.", comment: "Re-Enter new PIN instruction")
		static let caption = Localization(key: "UpdatePin.caption", value: "Remember this PIN. If you forget it, you won't be able to access your Litecoin.", comment: "Update PIN caption text")
		static let setPinErrorTitle = Localization(key: "UpdatePin.setPinErrorTitle", value: "Update PIN Error", comment: "Update PIN failure alert view title")
		static let setPinError = Localization(key: "UpdatePin.setPinError", value: "Sorry, could not update PIN.", comment: "Update PIN failure error message.")
	}

	enum RecoverWallet {
		static let next = Localization(key: "RecoverWallet.next", value: "Next", comment: "Next button label")
		static let intro = Localization(key: "RecoverWallet.intro", value: "Recover your Litewallet with your paper key.", comment: "Recover wallet intro")
		static let leftArrow = Localization(key: "RecoverWallet.leftArrow", value: "Left Arrow", comment: "Previous button accessibility label")
		static let rightArrow = Localization(key: "RecoverWallet.rightArrow", value: "Right Arrow", comment: "Next button accessibility label")
		static let done = Localization(key: "RecoverWallet.done", value: "Done", comment: "Done button text")
		static let instruction = Localization(key: "RecoverWallet.instruction", value: "Enter Paper Key", comment: "Enter paper key instruction")
		static let header = Localization(key: "RecoverWallet.header", value: "Recover Wallet", comment: "Recover wallet header")
		static let subheader = Localization(key: "RecoverWallet.subheader", value: "Enter the paper key for the wallet you want to recover.", comment: "Recover wallet sub-header")

		static let headerResetPin = Localization(key: "RecoverWallet.header_reset_pin", value: "Reset PIN", comment: "Reset PIN with paper key: header")
		static let subheaderResetPin = Localization(key: "RecoverWallet.subheader_reset_pin", value: "To reset your PIN, enter the words from your paper key into the boxes below.", comment: "Reset PIN with paper key: sub-header")
		static let resetPinInfo = Localization(key: "RecoverWallet.reset_pin_more_info", value: "Tap here for more information.", comment: "Reset PIN with paper key: more information button.")
		static let invalid = Localization(key: "RecoverWallet.invalid", value: "The paper key you entered is invalid. Please double-check each word and try again.", comment: "Invalid paper key message")
	}

	enum ManageWallet {
		static let title = Localization(key: "ManageWallet.title", value: "Manage Wallet", comment: "Manage wallet modal title")
		static let textFieldLabel = Localization(key: "ManageWallet.textFeildLabel", value: "Wallet Name", comment: "Change Wallet name textfield label")
		static let description = Localization(key: "ManageWallet.description", value: "Your wallet name only appears in your account transaction history and cannot be seen by anyone else.", comment: "Manage wallet description text")
		static let creationDatePrefix = Localization(key: "ManageWallet.creationDatePrefix", value: "You created your wallet on %1$@", comment: "Wallet creation date prefix")
		static let balance = Localization(key: "ManageWallet.balance", value: "Balance", comment: "Balance")
	}

	enum AccountHeader {
		static let defaultWalletName = Localization(key: "AccountHeader.defaultWalletName", value: "My Litewallet", comment: "Default wallet name")
		static let manageButtonName = Localization(key: "AccountHeader.manageButtonName", value: "MANAGE", comment: "Manage wallet button title")
	}

	enum VerifyPin {
		static let title = Localization(key: "VerifyPin.title", value: "PIN Required", comment: "Verify PIN view title")
		static let continueBody = Localization(key: "VerifyPin.continueBody", value: "Please enter your PIN to continue.", comment: "Verify PIN view body")
		static let authorize = Localization(key: "VerifyPin.authorize", value: "Please enter your PIN to authorize this transaction.", comment: "Verify PIN for transaction view body")
		static let touchIdMessage = Localization(key: "VerifyPin.touchIdMessage", value: "Authorize this transaction", comment: "Authorize transaction with touch id message")
	}

	enum TouchIdSettings {
		static let title = Localization(key: "TouchIdSettings.title", value: "Touch ID", comment: "Touch ID settings view title")
		static let label = Localization(key: "TouchIdSettings.label", value: "Use your fingerprint to unlock your Litewallet and send money up to a set limit.", comment: "Touch Id screen label")
		static let switchLabel = Localization(key: "TouchIdSettings.switchLabel", value: "Enable Touch ID for Litewallet", comment: "Touch id switch label.")
		static let unavailableAlertTitle = Localization(key: "TouchIdSettings.unavailableAlertTitle", value: "Touch ID Not Set Up", comment: "Touch ID unavailable alert title")
		static let unavailableAlertMessage = Localization(key: "TouchIdSettings.unavailableAlertMessage", value: "You have not set up Touch ID on this device. Go to Settings->Touch ID & Passcode to set it up now.", comment: "Touch ID unavailable alert message")
		static let spendingLimit = Localization(key: "TouchIdSettings.spendingLimit", value: "Spending limit: %1$@ (%2$@)", comment: "Spending Limit: b100,000 ($100)")
		static let limitValue = Localization(key: "TouchIdSettings.limitValue", value: "%1$@ (%2$@)", comment: " ł100,000 ($100)")
		static let customizeText = Localization(key: "TouchIdSettings.customizeText", value: "You can customize your Touch ID spending limit from the %1$@.", comment: "You can customize your Touch ID Spending Limit from the [TouchIdSettings.linkText gets added here as a button]")
		static let linkText = Localization(key: "TouchIdSettings.linkText", value: "Touch ID Spending Limit Screen", comment: "Link Text (see TouchIdSettings.customizeText)")
	}

	enum FaceIDSettings {
		static let title = Localization(key: "FaceIDSettings.title", value: "Face ID", comment: "Face ID settings view title")
		static let label = Localization(key: "FaceIDSettings.label", value: "Use your face to unlock your Litewallet and send money up to a set limit.", comment: "Face ID screen label")
		static let switchLabel = Localization(key: "FaceIDSettings.switchLabel", value: "Enable Face ID for Litewallet", comment: "Face id switch label.")
		static let unavailableAlertTitle = Localization(key: "FaceIDSettings.unavailableAlertTitle", value: "Face ID Not Set Up", comment: "Face ID unavailable alert title")
		static let unavailableAlertMessage = Localization(key: "FaceIDSettings.unavailableAlertMessage", value: "You have not set up Face ID on this device. Go to Settings->Face ID & Passcode to set it up now.", comment: "Face ID unavailable alert message")
		static let customizeText = Localization(key: "FaceIDSettings.customizeText", value: "You can customize your Face ID spending limit from the %1$@.", comment: "You can customize your Face ID Spending Limit from the [TouchIdSettings.linkText gets added here as a button]")
		static let linkText = Localization(key: "FaceIDSettings.linkText", value: "Face ID Spending Limit Screen", comment: "Link Text (see TouchIdSettings.customizeText)")
	}

	enum SpendingLimit {
		static let titleLabel = Localization(key: "SpendingLimit.title", value: "Current Spending Limit: ", comment: "Current spending limit:")
	}

	enum TouchIdSpendingLimit {
		static let title = Localization(key: "TouchIdSpendingLimit.title", value: "Touch ID Spending Limit", comment: "Touch Id spending limit screen title")
		static let body = Localization(key: "TouchIdSpendingLimit.body", value: "You will be asked to enter your 6-digit PIN to send any transaction over your spending limit, and every 48 hours since the last time you entered your 6-digit PIN.", comment: "Touch ID spending limit screen body")
		static let requirePasscode = Localization(key: "TouchIdSpendingLimit", value: "Always require passcode", comment: "Always require passcode option")
	}

	enum FaceIdSpendingLimit {
		static let title = Localization(key: "FaceIDSpendingLimit.title", value: "Face ID Spending Limit", comment: "Face Id spending limit screen title")
	}

	// MARK: - Settings

	enum Settings {
		static let title = Localization(key: "Settings.title", value: "Settings", comment: "Settings title")
		static let wallet = Localization(key: "Settings.wallet", value: "Wallet", comment: "Wallet Settings section header")
		static let manage = Localization(key: "Settings.manage", value: "Manage", comment: "Manage settings section header")
		static let support = Localization(key: "Settings.support", value: "Support", comment: "Support settings section header")
		static let blockchain = Localization(key: "Settings.blockchain", value: "Blockchain", comment: "Blockchain settings section header")
		static let importTile = Localization(key: "Settings.importTitle", value: "Import Wallet", comment: "Import wallet label")
		static let notifications = Localization(key: "Settings.notifications", value: "Notifications", comment: "Notifications label")
		static let touchIdLimit = Localization(key: "Settings.touchIdLimit", value: "Touch ID Spending Limit", comment: "Touch ID spending limit label")
		static let currency = Localization(key: "Settings.currency", value: "Display Currency", comment: "Default currency label")
		static let sync = Localization(key: "Settings.sync", value: "Sync Blockchain", comment: "Sync blockchain label")
		static let shareData = Localization(key: "Settings.shareData", value: "Share Anonymous Data", comment: "Share anonymous data label")
		static let earlyAccess = Localization(key: "Settings.earlyAccess", value: "Join Early Access", comment: "Join Early access label")
		static let about = Localization(key: "Settings.about", value: "About", comment: "About label")
		static let review = Localization(key: "Settings.review", value: "Leave us a Review", comment: "Leave review button label")
		static let enjoying = Localization(key: "Settings.enjoying", value: "Are you enjoying Litewallet?", comment: "Are you enjoying Litewallet alert message body")
		static let wipe = Localization(key: "Settings.wipe", value: "Start/Recover Another Wallet", comment: "Start or recover another wallet menu label.")
		static let advancedTitle = Localization(key: "Settings.advancedTitle", value: "Advanced Settings", comment: "Advanced Settings title")
		static let faceIdLimit = Localization(key: "Settings.faceIdLimit", value: "Face ID Spending Limit", comment: "Face ID spending limit label")
		static let languages = Localization(key: "Settings.languages", value: "Languages", comment: "Languages label")
		static let litewalletVersion = Localization(key: "Settings.litewallet.version", value: "Litewallet Version:", comment: "Litewallet version")
		static let litewalletEnvironment = Localization(key: "Settings.litewallet.environment", value: "Litewallet Environment:", comment: "Litewallet environment")
		static let socialLinks = Localization(key: "Settings.socialLinks", value: "Social Links:", comment: "Litewallet Social links")
		static let litewalletPartners = Localization(key: "Settings.litewallet.partners", value: "Litewallet Partners:", comment: "Litewallet Partners")
		static let currentLocale = Localization(key: "Settings.currentLocale", value: "Current Locale:", comment: "Current Locale")
		static let changeLanguageMessage = Localization(key: "Settings.ChangeLanguage.alertMessage", value: nil, comment: nil)
	}

	enum About {
		static let title = Localization(key: "About.title", value: "About", comment: "About screen title")
		static let blog = Localization(key: "About.blog", value: "Website", comment: "About screen website label")
		static let twitter = Localization(key: "About.twitter", value: "Twitter", comment: "About screen twitter label")
		static let reddit = Localization(key: "About.reddit", value: "Reddit", comment: "About screen reddit label")
		static let privacy = Localization(key: "About.privacy", value: "Privacy Policy", comment: "Privay Policy button label")
		static let footer = Localization(key: "About.footer", value: "Made by the LiteWallet Team\nof the\nLitecoin Foundation\n%1$@", comment: "About screen footer")
	}

	enum PushNotifications {
		static let title = Localization(key: "PushNotifications.title", value: "Notifications", comment: "Push notifications settings view title label")
		static let body = Localization(key: "PushNotifications.body", value: "Turn on notifications to receive special messages from Litewallet in the future.", comment: "Push notifications settings view body")
		static let label = Localization(key: "PushNotifications.label", value: "Push Notifications", comment: "Push notifications toggle switch label")
		static let on = Localization(key: "PushNotifications.on", value: "On", comment: "Push notifications are on label")
		static let off = Localization(key: "PushNotifications.off", value: "Off", comment: "Push notifications are off label")
	}

	enum DefaultCurrency {
		static let rateLabel = Localization(key: "DefaultCurrency.rateLabel", value: "Exchange Rate", comment: "Exchange rate label")
		static let bitcoinLabel = Localization(key: "DefaultCurrency.bitcoinLabel", value: "Litecoin Display Unit", comment: "Litecoin denomination picker label")
		static let chooseFiatLabel = Localization(key: "DefaultCurrency.chooseFiatLabel", value: "Choose Fiat:", comment: "Label to pick fiat")
	}

	enum SyncingView {
		static let syncing = Localization(key: "SyncingView.syncing", value: "Syncing", comment: "Syncing view syncing state header text")
		static let connecting = Localization(key: "SyncingView.connecting", value: "Connecting", comment: "Syncing view connectiong state header text")
	}

	enum SyncingHeader {
		static let syncing = Localization(key: "SyncingHeader.syncing", value: "Syncing...", comment: "Syncing view syncing state header text")
		static let connecting = Localization(key: "SyncingHeader.connecting", value: "Connecting...", comment: "Syncing view connection state header text")
		static let success = Localization(key: "SyncingHeader.success", value: "Success!", comment: "Syncing header success state header text")
		static let rescanning = Localization(key: "SyncingHeader.rescan", value: "Rescanning...*", comment: "Rescanning header success state header text")
	}

	enum ReScan {
		static let header = Localization(key: "ReScan.header", value: "Sync Blockchain", comment: "Sync Blockchain view header")
		static let subheader1 = Localization(key: "ReScan.subheader1", value: "Estimated time", comment: "Subheader label")
		static let subheader2 = Localization(key: "ReScan.subheader2", value: "When to Sync?", comment: "Subheader label")
		static let body1 = Localization(key: "ReScan.body1", value: "20-45 minutes", comment: "extimated time")
		static let body2 = Localization(key: "ReScan.body2", value: "If a transaction shows as completed on the Litecoin network but not in your Litewallet.", comment: "Syncing explanation")
		static let body3 = Localization(key: "ReScan.body3", value: "You repeatedly get an error saying your transaction was rejected.", comment: "Syncing explanation")
		static let buttonTitle = Localization(key: "ReScan.buttonTitle", value: "Start Sync", comment: "Start Sync button label")
		static let footer = Localization(key: "ReScan.footer", value: "You will not be able to send money while syncing with the blockchain.", comment: "Sync blockchain view footer")
		static let alertTitle = Localization(key: "ReScan.alertTitle", value: "Sync with Blockchain?", comment: "Alert message title")
		static let alertMessage = Localization(key: "ReScan.alertMessage", value: "You will not be able to send money while syncing.", comment: "Alert message body")
		static let alertAction = Localization(key: "ReScan.alertAction", value: "Sync", comment: "Alert action button label")
	}

	enum ShareData {
		static let header = Localization(key: "ShareData.header", value: "Share Data?", comment: "Share data header")
		static let body = Localization(key: "ShareData.body", value: "Help improve Litewallet by sharing your anonymous data with us. This does not include any financial information. We respect your financial privacy.", comment: "Share data view body")
		static let toggleLabel = Localization(key: "ShareData.toggleLabel", value: "Share Anonymous Data?", comment: "Share data switch label.")
	}

	enum ConfirmPaperPhrase {
		static let word = Localization(key: "ConfirmPaperPhrase.word", value: "Word #%1$@", comment: "Word label eg. Word #1, Word #2")
		static let label = Localization(key: "ConfirmPaperPhrase.label", value: "To make sure everything was written down correctly, please enter the following words from your paper key.", comment: "Confirm paper phrase view label.")
		static let error = Localization(key: "ConfirmPaperPhrase.error", value: "The words entered do not match your paper key. Please try again.", comment: "Confirm paper phrase error message")
	}

	enum StartPaperPhrase {
		static let body = Localization(key: "StartPaperPhrase.body", value: "Your paper key is the only way to restore your Litewallet if your mobile is unavailable.\n No one in the Litecoin Foundation team can give this paper key to you!\n\nWe will show you a list of words to write down on a piece of paper and keep safe.\n\nPLEASE MAKE BACKUPS AND DON'T LOSE IT!", comment: "Paper key explanation text.")
		static let buttonTitle = Localization(key: "StartPaperPhrase.buttonTitle", value: "Write Down Paper Key", comment: "button label")
		static let againButtonTitle = Localization(key: "StartPaperPhrase.againButtonTitle", value: "Write Down Paper Key Again", comment: "button label")
		static let date = Localization(key: "StartPaperPhrase.date", value: "You last wrote down your paper key on %1$@", comment: "Argument is date")
	}

	enum WritePaperPhrase {
		static let instruction = Localization(key: "WritePaperPhrase.instruction", value: "Write down each word in order and store it in a safe place.", comment: "Paper key instructions.")
		static let step = Localization(key: "WritePaperPhrase.step", value: "%1$d of %2$d", comment: "1 of 3")
		static let next = Localization(key: "WritePaperPhrase.next", value: "Next", comment: "button label")
		static let previous = Localization(key: "WritePaperPhrase.previous", value: "Previous", comment: "button label")
	}

	enum TransactionDirection {
		static let to = Localization(key: "TransactionDirection.to", value: "Sent to this Address", comment: "(this transaction was) Sent to this address:")
		static let received = Localization(key: "TransactionDirection.address", value: "Received at this Address", comment: "(this transaction was) Received at this address:")
	}

	enum RequestAnAmount {
		static let title = Localization(key: "RequestAnAmount.title", value: "Request an Amount", comment: "Request a specific amount of Litecoin")
		static let noAmount = Localization(key: "RequestAnAmount.noAmount", value: "Please enter an amount first.", comment: "No amount entered error message.")
	}

	// MARK: - Security Alerts

	enum SecurityAlerts {
		static let pinSet = Localization(key: "Alerts.pinSet", value: "PIN Set", comment: "Alert Header label (the PIN was set)")
		static let paperKeySet = Localization(key: "Alerts.paperKeySet", value: "Paper Key Set", comment: "Alert Header Label (the paper key was set)")
		static let sendSuccess = Localization(key: "Alerts.sendSuccess", value: "Send Confirmation", comment: "Send success alert header label (confirmation that the send happened)")
		static let resolvedSuccess = Localization(key: "Alerts.resolvedSuccess", value: "Resolved Success", comment: "Resolved Success")
		static let resolvedSuccessSubheader = Localization(key: "Alerts.resolvedSuccessSubheader", value: "Resolved", comment: "Resolved Success subheader")
		static let sendFailure = Localization(key: "Alerts.sendFailure", value: "Send failed", comment: "Send failure alert header label (the send failed to happen)")
		static let paperKeySetSubheader = Localization(key: "Alerts.paperKeySetSubheader", value: "Awesome!", comment: "Alert Subheader label (playfully positive)")
		static let sendSuccessSubheader = Localization(key: "Alerts.sendSuccessSubheader", value: "Money Sent!", comment: "Send success alert subheader label (e.g. the money was sent)")
		static let copiedAddressesHeader = Localization(key: "Alerts.copiedAddressesHeader", value: "Addresses Copied", comment: "'the addresses were copied'' Alert title")
		static let copiedAddressesSubheader = Localization(key: "Alerts.copiedAddressesSubheader", value: "All wallet addresses successfully copied.", comment: "Addresses Copied Alert sub header")
	}

	enum MenuButton {
		static let security = Localization(key: "MenuButton.security", value: "Security Center", comment: "Menu button title")
		static let support = Localization(key: "MenuButton.customer.support", value: "Customer support", comment: "Menu button title")
		static let settings = Localization(key: "MenuButton.settings", value: "Settings", comment: "Menu button title")
		static let lock = Localization(key: "MenuButton.lock", value: "Lock Wallet", comment: "Menu button title")
		static let buy = Localization(key: "MenuButton.buy", value: "Buy Litecoin", comment: "Buy Litecoin title")
	}

	enum MenuViewController {
		static let modalTitle = Localization(key: "MenuViewController.modalTitle", value: "Menu", comment: "Menu modal title")
	}

	enum StartViewController {
		static let createButton = Localization(key: "MenuViewController.createButton", value: "Create New Wallet", comment: "button label")
		static let recoverButton = Localization(key: "MenuViewController.recoverButton", value: "Recover Wallet", comment: "button label")
		static let tagline = Localization(key: "StartViewController.tagline", value: "The most secure and safest way to use Litecoin.", comment: "Start view message")
	}

	enum AccessibilityLabels {
		static let close = Localization(key: "AccessibilityLabels.close", value: "Close", comment: "Close modal button accessibility label")
		static let faq = Localization(key: "AccessibilityLabels.faq", value: "Support Center", comment: "Support center accessibiliy label")
	}

	enum Search {
		static let sent = Localization(key: "Search.sent", value: "sent", comment: "Sent filter label")
		static let received = Localization(key: "Search.received", value: "received", comment: "Received filter label")
		static let pending = Localization(key: "Search.pending", value: "pending", comment: "Pending filter label")
		static let complete = Localization(key: "Search.complete", value: "complete", comment: "Complete filter label")
	}

	enum Prompts {
		static let affirm = Localization(key: "Prompts.PaperKey.affirm", value: "Continue", comment: "Affirm button title.")
		static let cancel = Localization(key: "Prompts.PaperKey.cancel", value: "Cancel", comment: "Cancel button.")
		static let enable = Localization(key: "Prompts.PaperKey.enable", value: "Enable", comment: "Enable button.")
		static let dismiss = Localization(key: "Prompts.dismiss", value: "**Dismiss", comment: "Dismiss button.")
		enum TouchId {
			static let title = Localization(key: "Prompts.TouchId.title", value: "Enable Touch ID", comment: "Enable touch ID prompt title")
			static let body = Localization(key: "Prompts.TouchId.body", value: "Tap here to enable Touch ID", comment: "Enable touch ID prompt body")
		}

		enum PaperKey {
			static let title = Localization(key: "Prompts.PaperKey.title", value: "Action Required", comment: "An action is required (You must do this action).")
			static let body = Localization(key: "Prompts.PaperKey.body", value: "Your Paper Key must be kept in a safe place. It is the only way modify or restore your Litewallet or transfer your Litecoin. Please write it down.", comment: "Warning about paper key.")
		}

		enum SetPin {
			static let title = Localization(key: "Prompts.SetPin.title", value: "Set PIN", comment: "Set PIN prompt title.")
			static let body = Localization(key: "Prompts.SetPin.body", value: "Litewallet requires a 6-digit PIN. Please set and store your PIN in a safe place.", comment: "Upgrade PIN prompt body.")
		}

		enum RecommendRescan {
			static let title = Localization(key: "Prompts.RecommendRescan.title", value: "Transaction Rejected", comment: "Transaction rejected prompt title")
			static let body = Localization(key: "Prompts.RecommendRescan.body", value: "Your wallet may be out of sync. This can often be fixed by rescanning the blockchain.", comment: "Transaction rejected prompt body")
		}

		enum NoPasscode {
			static let title = Localization(key: "Prompts.NoPasscode.title", value: "Turn device passcode on", comment: "No Passcode set warning title")
			static let body = Localization(key: "Prompts.NoPasscode.body", value: "A device passcode is needed to safeguard your wallet.", comment: "No passcode set warning body")
		}

		enum ShareData {
			static let title = Localization(key: "Prompts.ShareData.title", value: "Share Anonymous Data", comment: "Share data prompt title")
			static let body = Localization(key: "Prompts.ShareData.body", value: "Help improve Litewallet by sharing your anonymous data with us", comment: "Share data prompt body")
		}

		enum FaceId {
			static let title = Localization(key: "Prompts.FaceId.title", value: "Enable Face ID", comment: "Enable face ID prompt title")
			static let body = Localization(key: "Prompts.FaceId.body", value: "Tap here to enable Face ID", comment: "Enable face ID prompt body")
		}
	}

	// MARK: - Payment Protocol

	enum PaymentProtocol {
		enum Errors {
			static let untrustedCertificate = Localization(key: "PaymentProtocol.Errors.untrustedCertificate", value: "untrusted certificate", comment: "Untrusted certificate payment protocol error message")
			static let missingCertificate = Localization(key: "PaymentProtocol.Errors.missingCertificate", value: "missing certificate", comment: "Missing certificate payment protocol error message")
			static let unsupportedSignatureType = Localization(key: "PaymentProtocol.Errors.unsupportedSignatureType", value: "unsupported signature type", comment: "Unsupported signature type payment protocol error message")
			static let requestExpired = Localization(key: "PaymentProtocol.Errors.requestExpired", value: "request expired", comment: "Request expired payment protocol error message")
			static let badPaymentRequest = Localization(key: "PaymentProtocol.Errors.badPaymentRequest", value: "Bad Payment Request", comment: "Bad Payment request alert title")
			static let smallOutputErrorTitle = Localization(key: "PaymentProtocol.Errors.smallOutputError", value: "Couldn't make payment", comment: "Payment too small alert title")
			static let smallPayment = Localization(key: "PaymentProtocol.Errors.smallPayment", value: "Litecoin payments can't be less than %1$@.", comment: "Amount too small error message")
			static let smallTransaction = Localization(key: "PaymentProtocol.Errors.smallTransaction", value: "Litecoin transaction outputs can't be less than $@.", comment: "Output too small error message.")
			static let corruptedDocument = Localization(key: "PaymentProtocol.Errors.corruptedDocument", value: "Unsupported or corrupted document", comment: "Error opening payment protocol file message")
		}
	}

	enum URLHandling {
		static let addressListAlertTitle = Localization(key: "URLHandling.addressListAlertTitle", value: "Copy Wallet Addresses", comment: "Authorize to copy wallet address alert title")
		static let addressListAlertMessage = Localization(key: "URLHandling.addressaddressListAlertMessage", value: "Copy wallet addresses to clipboard?", comment: "Authorize to copy wallet addresses alert message")
		static let addressListVerifyPrompt = Localization(key: "URLHandling.addressList", value: "Authorize to copy wallet address to clipboard", comment: "Authorize to copy wallet address PIN view prompt.")
		static let copy = Localization(key: "URLHandling.copy", value: "Copy", comment: "Copy wallet addresses alert button label")
	}

	enum ApiClient {
		static let notReady = Localization(key: "ApiClient.notReady", value: "Wallet not ready", comment: "Wallet not ready error message")
		static let jsonError = Localization(key: "ApiClient.jsonError", value: "JSON Serialization Error", comment: "JSON Serialization error message")
		static let tokenError = Localization(key: "ApiClient.tokenError", value: "Unable to retrieve API token", comment: "API Token error message")
	}

	enum CameraPlugin {
		static let centerInstruction = Localization(key: "CameraPlugin.centerInstruction", value: "Center your ID in the box", comment: "Camera plugin instruction")
	}

	enum LocationPlugin {
		static let disabled = Localization(key: "LocationPlugin.disabled", value: "Location services are disabled.", comment: "Location services disabled error")
		static let notAuthorized = Localization(key: "LocationPlugin.notAuthorized", value: "Litewallet does not have permission to access location services.", comment: "No permissions for location services")
	}

	enum Webview {
		static let updating = Localization(key: "Webview.updating", value: "Updating...", comment: "Updating webview message")
		static let errorMessage = Localization(key: "Webview.errorMessage", value: "There was an error loading the content. Please try again.", comment: "Webview loading error message")
		static let dismiss = Localization(key: "Webview.dismiss", value: "Dismiss", comment: "Dismiss button label")
	}

	enum TimeSince {
		static let seconds = Localization(key: "TimeSince.seconds", value: "%1$@ s", comment: "6 s (6 seconds)")
		static let minutes = Localization(key: "TimeSince.minutes", value: "%1$@ m", comment: "6 m (6 minutes)")
		static let hours = Localization(key: "TimeSince.hours", value: "%1$@ h", comment: "6 h (6 hours)")
		static let days = Localization(key: "TimeSince.days", value: "%1$@ d", comment: "6 d (6 days)")
	}

	enum Import {
		static let leftCaption = Localization(key: "Import.leftCaption", value: "Wallet to be imported", comment: "Caption for graphics")
		static let rightCaption = Localization(key: "Import.rightCaption", value: "Your Litewallet Wallet", comment: "Caption for graphics")
		static let importMessage = Localization(key: "Import.message", value: "Importing a wallet transfers all the money from your other wallet into your Litewallet wallet using a single transaction.", comment: "Import wallet intro screen message")
		static let importWarning = Localization(key: "Import.warning", value: "Importing a wallet does not include transaction history or other details.", comment: "Import wallet intro warning message")
		static let scan = Localization(key: "Import.scan", value: "Scan Private Key", comment: "Scan Private key button label")
		static let title = Localization(key: "Import.title", value: "Import Wallet", comment: "Import Wallet screen title")
		static let importing = Localization(key: "Import.importing", value: "Importing Wallet", comment: "Importing wallet progress view label")
		static let confirm = Localization(key: "Import.confirm", value: "Send %1$@ from this private key into your wallet? The Litecoin network will receive a fee of %2$@.", comment: "Sweep private key confirmation message")
		static let checking = Localization(key: "Import.checking", value: "Checking private key balance...", comment: "Checking private key balance progress view text")
		static let password = Localization(key: "Import.password", value: "This private key is password protected.", comment: "Enter password alert view title")
		static let passwordPlaceholder = Localization(key: "Import.passwordPlaceholder", value: "password", comment: "password textfield placeholder")
		static let unlockingActivity = Localization(key: "Import.unlockingActivity", value: "Unlocking Key", comment: "Unlocking Private key activity view message.")
		static let importButton = Localization(key: "Import.importButton", value: "Import", comment: "Import button label")
		static let success = Localization(key: "Import.success", value: "Success", comment: "Import wallet success alert title")
		static let successBody = Localization(key: "Import.SuccessBody", value: "Successfully imported wallet.", comment: "Successfully imported wallet message body")
		static let wrongPassword = Localization(key: "Import.wrongPassword", value: "Wrong password, please try again.", comment: "Wrong password alert message")
		enum Error {
			static let notValid = Localization(key: "Import.Error.notValid", value: "Not a valid private key", comment: "Not a valid private key error message")
			static let duplicate = Localization(key: "Import.Error.duplicate", value: "This private key is already in your wallet.", comment: "Duplicate key error message")
			static let empty = Localization(key: "Import.Error.empty", value: "This private key is empty.", comment: "empty private key error message")
			static let highFees = Localization(key: "Import.Error.highFees", value: "Transaction fees would cost more than the funds available on this private key.", comment: "High fees error message")
			static let signing = Localization(key: "Import.Error.signing", value: "Error signing transaction", comment: "Import signing error message")
		}
	}

	enum WipeWallet {
		static let title = Localization(key: "WipeWallet.title", value: "Start or Recover Another Wallet", comment: "Wipe wallet navigation item title.")
		static let alertTitle = Localization(key: "WipeWallet.alertTitle", value: "Wipe Wallet?", comment: "Wipe wallet alert title")
		static let alertMessage = Localization(key: "WipeWallet.alertMessage", value: "Are you sure you want to delete this wallet?", comment: "Wipe wallet alert message")
		static let wipe = Localization(key: "WipeWallet.wipe", value: "Wipe", comment: "Wipe wallet button title")
		static let wiping = Localization(key: "WipeWallet.wiping", value: "Wiping...", comment: "Wiping activity message")
		static let failedTitle = Localization(key: "WipeWallet.failedTitle", value: "Failed", comment: "Failed wipe wallet alert title")
		static let failedMessage = Localization(key: "WipeWallet.failedMessage", value: "Failed to wipe wallet.", comment: "Failed wipe wallet alert message")
		static let instruction = Localization(key: "WipeWallet.instruction", value: "To start a new wallet or restore an existing wallet, you must first erase the wallet that is currently installed. To continue, enter the current wallet's Paper Key.", comment: "Enter key to wipe wallet instruction.")
		static let startMessage = Localization(key: "WipeWallet.startMessage", value: "Starting or recovering another wallet allows you to access and manage a different Litewallet wallet on this device.", comment: "Start wipe wallet view message")
		static let startWarning = Localization(key: "WipeWallet.startWarning", value: "Your current wallet will be removed from this device. If you wish to restore it in the future, you will need to enter your Paper Key.", comment: "Start wipe wallet view warning")
		static let emptyWallet = Localization(key: "WipeWallet.emptyWallet", value: "Forget seed or PIN?", comment: "Warning if user lost phrase")
		static let resetTitle = Localization(key: "resetTitle", value: " Delete my Litewallet ", comment: "Warning Empty Wipe title")
		static let resetButton = Localization(key: "resetButton", value: "Yes, reset wallet", comment: "Reset walet button  title")
		static let warningTitle = Localization(key: "WipeWallet.warningTitle", value: "PLEASE READ!", comment: "Warning title")
		static let warningDescription = Localization(key: "WipeWallet.warningDescription", value: "Your LiteWallet is empty. Resetting will delete the old private key and wipe the app data.\n\nAfter the reset, be prepared to record the new 12 words and keep them in a very secure place.\n\nNo LiteWallet developers can retrieve this seed for you.", comment: "Warning description")
		static let warningAlert = Localization(key: "WipeWallet.warningAlert", value: "DO NOT LOSE IT!", comment: "Warning Alert")
		static let deleteDatabase = Localization(key: "WipeWallet.deleteDatabase", value: "Delete database", comment: "Delete db")
		static let alertDeleteTitle = Localization(key: "WipeWallet.alertDeleteTitle", value: "Delet Database", comment: "Delete database title")
		static let deleteMessageTitle = Localization(key: "WipeWallet.deleteMessageTitle", value: "This deletes the database but retains the PIN and phrase. You will be asked to confirm your existing PIN, seed and will re-sync the new db", comment: "Delete database message")
		static let deleteSync = Localization(key: "WipeWallet.deleteSync", value: "Delete & Sync", comment: "Delete and sync")
	}

	enum FeeSelector {
		static let title = Localization(key: "FeeSelector.title", value: "Processing Speed", comment: "Fee Selector title")
		static let regularLabel = Localization(key: "FeeSelector.regularLabel", value: "Estimated Delivery: 2.5 - 5+ minutes", comment: "Fee Selector regular fee description")
		static let economyLabel = Localization(key: "FeeSelector.economyLabel", value: "Estimated Delivery: ~10 minutes", comment: "Fee Selector economy fee description")
		static let luxuryLabel = Localization(key: "FeeSelector.luxuryLabel", value: "Delivery: 2.5 - 5+  minutes", comment: "Fee Selector luxury fee description")
		static let economyWarning = Localization(key: "FeeSelector.economyWarning", value: "This option is not recommended for time-sensitive transactions.", comment: "Warning message for economy fee")
		static let luxuryMessage = Localization(key: "FeeSelector.luxuryMessage", value: "This option virtually guarantees acceptance of your transaction while you pay a premium.", comment: "Message for luxury fee")

		static let regular = Localization(key: "FeeSelector.regular", value: "Regular", comment: "Regular fee")
		static let economy = Localization(key: "FeeSelector.economy", value: "Economy", comment: "Economy fee")
		static let luxury = Localization(key: "FeeSelector.luxury", value: "Luxury", comment: "Luxury fee")
	}

	enum Confirmation {
		static let title = Localization(key: "Confirmation.title", value: "Confirmation", comment: "Confirmation Screen title")
		static let send = Localization(key: "Confirmation.send", value: "Send", comment: "Send: (amount)")
		static let to = Localization(key: "Confirmation.to", value: "To", comment: "To: (address)")
		static let staticAddressLabel = Localization(key: "Confirmation.staticAddressLabel", value: "ADDRESS:", comment: "Address label")

		static let processingTime = Localization(key: "Confirmation.processingTime", value: "Processing time: This transaction will take %1$@ minutes to process.", comment: "eg. Processing time: This transaction will take 10-30 minutes to process.")
		static let processingAndDonationTime = Localization(key: "Confirmation.processingAndDonationTime", value: "Processing time: These transactions will take %1$@ minutes to process.", comment: "eg. Processing with Donation time: This transaction will take 10-30 minutes to process.")
		static let amountLabel = Localization(key: "Confirmation.amountLabel", value: "Amount to Send:", comment: "Amount to Send: ($1.00)")
		static let donateLabel = Localization(key: "Confirmation.donateLabel", value: "Amount to Donate:", comment: "Amount to Donate: ($1.00)")

		static let totalLabel = Localization(key: "Confirmation.totalLabel", value: "Total Cost:", comment: "Total Cost: ($5.00)")
		static let amountDetailLabel = Localization(key: "Confirmation.amountDetailLabel", value: "Exchange details:", comment: "$53.09/L + 1.07%")
	}

	enum NodeSelector {
		static let manualButton = Localization(key: "NodeSelector.manualButton", value: "Switch to Manual Mode", comment: "Switch to manual mode button label")
		static let automaticButton = Localization(key: "NodeSelector.automaticButton", value: "Switch to Automatic Mode", comment: "Switch to automatic mode button label")
		static let title = Localization(key: "NodeSelector.title", value: "Litecoin Nodes", comment: "Node Selector view title")
		static let nodeLabel = Localization(key: "NodeSelector.nodeLabel", value: "Current Primary Node", comment: "Node address label")
		static let statusLabel = Localization(key: "NodeSelector.statusLabel", value: "Node Connection Status", comment: "Node status label")
		static let connected = Localization(key: "NodeSelector.connected", value: "Connected", comment: "Node is connected label")
		static let notConnected = Localization(key: "NodeSelector.notConnected", value: "Not Connected", comment: "Node is not connected label")
		static let enterTitle = Localization(key: "NodeSelector.enterTitle", value: "Enter Node", comment: "Enter Node ip address view title")
		static let enterBody = Localization(key: "NodeSelector.enterBody", value: "Enter Node IP address and port (optional)", comment: "Enter node ip address view body")
	}

	enum Welcome {
		static let title = Localization(key: "Welcome.title", value: "Welcome to Litewallet", comment: "Welcome view title")
		static let body = Localization(key: "Welcome.body", value: "Litewallet now has a brand new look and some new features.\n\nAll coins are displayed in lites (ł). 1 Litecoin (Ł) = 1000 lites (ł).", comment: "Welcome view body text")
	}

	enum Fragments {
		static let or = Localization(key: "Fragment.or", value: "or", comment: "Or")
		static let confirm = Localization(key: "Fragment.confirm", value: "confirm", comment: "Confirm")
		static let to = Localization(key: "Fragment.to", value: "to", comment: "to")
		static let sorry = Localization(key: "Fragment.sorry", value: "sorry", comment: "sorry")
	}
}
