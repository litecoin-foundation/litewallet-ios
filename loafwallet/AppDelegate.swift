//
//  AppDelegate.swift
//  breadwallet
//
//  Created by Aaron Voisine on 10/5/16.
//  Copyright (c) 2016 breadwallet LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import SwiftUI
import LocalAuthentication
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let applicationController = ApplicationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setFirebaseConfiguration()
        
        updateCurrentUserLocale(localeId: Locale.current.identifier)
        
        UIView.swizzleSetFrame()
        
        applicationController.launch(application: application, window: self.window, options: launchOptions)
        
        LWAnalytics.logEventWithParameters(itemName:._20191105_AL)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        applicationController.willEnterForeground()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        applicationController.didEnterBackground()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        applicationController.willResignActive()
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        applicationController.performFetch(completionHandler)
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
        return false // disable extensions such as custom keyboards for security purposes
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return applicationController.open(url: url)
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    /// Sets the correct Google Services  plist file
    private func setFirebaseConfiguration() {
        
        #if Release
            // Loads the release Firebase config file.
            FirebaseApp.configure()
        #else
            // Load a Firebase debug config file.
            let filePath = Bundle.main.path(forResource: "Debug-GoogleService-Info", ofType: "plist")
            guard let fileOpts = FirebaseOptions(contentsOfFile: filePath!)
            else { assert(false, "Couldn't load Firebase config file") }
            FirebaseApp.configure(options: fileOpts)
        #endif
    }
    
    /// Check Locale
    func updateCurrentUserLocale(localeId: String) {
          
        let suffix = String(localeId.suffix(3))
        
        if suffix == "_US" {
            UserDefaults.userIsInUSA = true
        } else {
            UserDefaults.userIsInUSA = false
        }
    }
}



