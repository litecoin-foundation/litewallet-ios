//
//  LocalWebView.swift
//  loafwallet
//
//  Created by Kerry Washington on 10/8/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import WebKit
import Combine
 
// MARK: - WebViewHandlerDelegate
protocol WebViewHandlerDelegate {
}

struct LocalWebView: UIViewRepresentable, WebViewHandlerDelegate {
    
    @ObservedObject
    var viewModel: LocalWebViewModel
      
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = true
        webView.customUserAgent = customUserAgent
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        if let url = Bundle.main.url(forResource: "bitrefill_index", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            NSLog("ERROR: Local html not found")
        }
    }
    
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: LocalWebView
        var delegate: WebViewHandlerDelegate?
        var valueSubscriber: AnyCancellable? = nil
        var webViewNavigationSubscriber: AnyCancellable? = nil
         
        init(_ uiWebView: LocalWebView) {
            self.parent = uiWebView
            self.delegate = parent
        }
        
        deinit {
            valueSubscriber?.cancel()
            webViewNavigationSubscriber?.cancel()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            self.parent.viewModel.showLoader.send(false)
        }
        
        //MARK: WKWebView's delegate functions
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // Hides loader
            parent.viewModel.showLoader.send(false)
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            // Shows loader
            parent.viewModel.showLoader.send(true)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // Shows loader
            parent.viewModel.showLoader.send(true)
        }
        
    }
}

// MARK: - Extensions
extension LocalWebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
    }
}


