//
//  SignupWebViewModel.swift
//  litewallet
//
//  Created by Kerry Washington on 1/9/24.
//  Copyright © 2024 Litecoin Foundation. All rights reserved.
//
import Combine
import Foundation

class SignupWebViewModel: ObservableObject {
	var showLoader = PassthroughSubject<Bool, Never>()
	var valuePublisher = PassthroughSubject<String, Never>()
}
