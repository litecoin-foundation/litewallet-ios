//
//  UnstoppableDomainViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/18/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UnstoppableDomainsResolution

class UnstoppableDomainViewModel: ObservableObject {
    
    //MARK: - Combine Variables
    @Published
    var searchString: String = ""
    
    @Published
    var placeholderString: String = S.Send.UnstoppableDomains.simplePlaceholder
    
    @Published
    var isDomainResolving: Bool = false
    
    //MARK: - Public Variables
    var didResolveUDAddress: ((String) -> Void)?
    
    var didFailToResolve: ((String) -> Void)?
    
    var domains: [String] = [".bitcoin",".blockchain", ".crypto", ".coin", ".dao", ".nft", ".wallet", ".x", ".zil", ".888"]
    

    private var domainIndex: Int = 0
    
    @Published
    var currentDomain: String = ""
     
    //MARK: - Private Variables
    private var ltcAddress = ""
    private var dateFormatter: DateFormatter? {
        
        didSet {
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "yyyy-MM-dd hh:mm:ss"
        }
    }
    
    init() {
         
        currentDomain = "\(domains[domainIndex])"
        animateDomain()
    }
    
    private func animateDomain() {
       
            delay(2.0) {
                
                if self.domainIndex < self.domains.count {
                    self.currentDomain = "\(self.domains[self.domainIndex])"
                    self.domainIndex += 1
                }
                else {
                    self.domainIndex = 0
                }
                self.animateDomain()
            }
        
    }
    
    func resolveDomain() {
        
        isDomainResolving = true
        
        // Added timing peroformance probes to see what the average time is
        let timestamp: String = self.dateFormatter?.string(from: Date()) ?? ""
        
        LWAnalytics.logEventWithParameters(itemName:
                                            CustomEvent._20201121_SIL,
                                           properties:
                                            ["start_time": timestamp])
        
        self.resolveUDAddress(domainName: searchString)
    }
    
    private func resolveUDAddress(domainName: String) {
         
        // This group is created to allow the threads to complete.
        // Otherwise, we may never get in the callback relative to UDR v4.0.0
        let group = DispatchGroup()
        
        guard let resolution = try? Resolution() else {
            print ("Init of Resolution instance with default parameters failed...")
            return
        }

        group.enter()
       
        resolution.addr(domain: domainName, ticker: "ltc") { result in
 
            switch result {
                case .success(let returnValue):

                    let timestamp: String = self.dateFormatter?.string(from: Date()) ?? ""

                    LWAnalytics.logEventWithParameters(itemName:
                                                        CustomEvent._20201121_DRIA,
                                                       properties:
                                                        ["success_time": timestamp])
                    ///Quicker resolution: When the resolution is done, the activity indicatior stops and the address is  updated
                    DispatchQueue.main.async {
                        self.ltcAddress = returnValue
                        self.didResolveUDAddress?(self.ltcAddress)
                        self.isDomainResolving = false
                    }

                case .failure(let error):
                    let errorMessage = DomainResolutionFailure().messageWith(error: error)
                    let timestamp: String = self.dateFormatter?.string(from: Date()) ?? ""

                    LWAnalytics.logEventWithParameters(itemName:
                                                        CustomEvent._20201121_FRIA,
                                                       properties:
                                                        ["failure_time": timestamp,
                                                         "error_message":errorMessage,
                                                         "error":error.localizedDescription])
 
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2,
                                                  execute: {

                                                    self.didFailToResolve?(error.localizedDescription)
                                                    self.didFailToResolve?(errorMessage)
                                                    self.isDomainResolving = false

                                                  })
            }
             group.leave()
        }
        group.wait()
    }
}
