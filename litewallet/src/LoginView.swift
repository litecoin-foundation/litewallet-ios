//
//  LoginView.swift
//  litewallet
//
//  Created by Kerry Washington on 12/25/23.
//  Copyright © 2023 Litecoin Foundation. All rights reserved.
//
import SwiftUI

struct LoginView: View {
	@ObservedObject
	var viewModel: LockScreenViewModel

	init(viewModel: LockScreenViewModel) {
		self.viewModel = viewModel

		/// lockScreenHeaderView
	}

	var body: some View {
		GeometryReader { _ in
			ZStack {
				Color.litewalletBlue.edgesIgnoringSafeArea(.all)
				VStack {
					Spacer()
				}
			}
		}
	}
}
