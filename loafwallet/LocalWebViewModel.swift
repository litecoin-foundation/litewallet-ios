//
//  LocalWebViewModel.swift
//  loafwallet

import Foundation
import Combine

class LocalWebViewModel: ObservableObject {
    
    var showLoader = PassthroughSubject<Bool, Never>()
    var valuePublisher = PassthroughSubject<String, Never>()
}
