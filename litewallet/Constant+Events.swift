import Foundation
import UIKit

/// Custom Event Enum: Events related to different user based actions
enum CustomEvent: String {
	/// App Launched
	case _20191105_AL = "app_launched"

	/// Visit Receive Controller
	case _20202116_VRC = "visited_received_controller"

	/// Visit Send Controller
	case _20191105_VSC = "visited_send_controller"

	/// Did Tap Buy Tab Controller
	case _20191105_DTBT = "did_tap_buy_tab"

	/// Did Send LTC
	case _20191105_DSL = "did_send_ltc"

	/// Did Tap Support
	case _20201118_DTS = "did_tap_support"

	/// Entered dispatch group
	case _20200111_DEDG = "did_enter_dispatch_group"

	/// Left dispatch group
	case _20200111_DLDG = "did_leave_dispatch_group"

	/// Rate not initialized
	case _20200111_RNI = "rate_not_initialized"

	/// Fee per kb not initialized
	case _20200111_FNI = "feeperkb_not_initialized"

	/// Transaction not initialized
	case _20200111_TNI = "transaction_not_initialized"

	/// Wallet not initialized
	case _20200111_WNI = "wallet_not_initialized"

	/// Phrase not initialized
	case _20200111_PNI = "phrase_not_initialized"

	/// Unable to sign transaction
	case _20200111_UTST = "unable_to_sign_transaction"

	/// Generalized Error
	case _20200112_ERR = "error"

	/// Keychain Lookup
	case _20210804_ERR_KLF = "error_key_lookup_failure"

	/// Started resync
	case _20200112_DSR = "did_start_resync"

	/// Showed review request
	case _20200125_DSRR = "did_show_review_request"

	/// Unlocked in with PIN
	case _20200217_DUWP = "did_unlock_with_pin"

	/// App Launched
	case _20200217_DUWB = "did_unlock_with_biometrics"

	/// Did use default fee per kb
	case _20200301_DUDFPK = "did_use_default_fee_per_kb"

	/// User tapped support LF
	case _20201118_DTGS = "did_tap_get_support"

	/// Started IFPS Lookup
	case _20201121_SIL = "started_IFPS_lookup"

	/// Resolved IPFS Address
	case _20201121_DRIA = "did_resolve_IPFS_address"

	/// Failed to resolve IPFS Address
	case _20201121_FRIA = "failed_resolve_IPFS_address"

	/// User tapped balance
	case _20200207_DTHB = "did_tap_header_balance"

	/// Ternio API Wallet details failure
	case _20210405_TAWDF = "ternio_api_wallet_details_failure"

	/// Ternio API Authenticate Enable 2FA change
	case _20210804_TAA2FAC = "ternio_API_auth_2FA_change"

	/// Ternio API Wallet details success
	case _20210804_TAWDS = "ternio_API_wallet_details_success"

	/// Ternio API Login
	case _20210804_TAULI = "ternio_API_user_log_in"

	/// Ternio API Logout
	case _20210804_TAULO = "ternio_API_user_log_out"

	/// Heartbeat check If event even happens
	case _20210427_HCIEEH = "heartbeat_check_if_event_even_happens"

	/// User Tapped on  UD Image
	case _20220822_UTOU = "user_tapped_on_ud"

	/// User registered Pusher interest
	case _20231202_RIGI = "registered_ios_general_interest"

	/// User accepted pushes
	case _20231225_UAP = "user_accepted_push"

	/// User signup
	case _20240101_US = "user_signup"
}
