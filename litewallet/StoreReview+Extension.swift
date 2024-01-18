import StoreKit

// Inspired by https://stackoverflow.com/questions/63953891/requestreview-was-deprecated-in-ios-14-0
public extension SKStoreReviewController {
	static func requestReviewInCurrentScene() {
		if let scene = UIApplication.shared
			.connectedScenes
			.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
		{
			DispatchQueue.main.async {
				requestReview(in: scene)
			}
		}
	}
}
