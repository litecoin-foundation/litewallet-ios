import Foundation
import StoreKit

extension ApplicationController {
	func setupDefaults() {
		if UserDefaults.standard.object(forKey: shouldRequireLoginTimeoutKey) == nil {
			UserDefaults.standard.set(60.0 * 3.0, forKey: shouldRequireLoginTimeoutKey) // Default 3 min timeout
		}
	}

	func countLaunches() {
		if var launchNumber = UserDefaults.standard.object(forKey: numberOfLitewalletLaunches) as? Int {
			launchNumber += 1
			UserDefaults.standard.set(NSNumber(value: launchNumber), forKey: numberOfLitewalletLaunches)
			if launchNumber == 5 {
				SKStoreReviewController.requestReview()

				SKStoreReviewController.requestReviewInCurrentScene()

				// iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
				// [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, YOUR_APP_STORE_ID]]; // Would contain the right link

				LWAnalytics.logEventWithParameters(itemName: ._20200125_DSRR)
			}
		} else {
			UserDefaults.standard.set(NSNumber(value: 1), forKey: numberOfLitewalletLaunches)
		}
	}

	func willResignActive()
	{}
}
