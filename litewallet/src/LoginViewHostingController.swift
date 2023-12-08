//
//  LoginViewHostingController.swift
//  litewallet
//
//  Created by Kerry Washington on 12/25/23.
//  Copyright © 2023 Litecoin Foundation. All rights reserved.
//
import Foundation
import SwiftUI

class LoginViewHostingController: UIHostingController<LoginView> {
	// MARK: - Private

	var viewModel: LockScreenViewModel

	init(store: Store, isPresentedForLock: Bool, walletManager: WalletManager? = nil) {
		viewModel = LockScreenViewModel(store: store,
		                                isPresentedForLock: isPresentedForLock,
		                                walletManager: walletManager)

		super.init(rootView: LoginView(viewModel: viewModel))
	}

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
