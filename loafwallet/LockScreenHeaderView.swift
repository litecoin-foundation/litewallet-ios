//
//  LockScreenHeaderView.swift
//  loafwallet
//
//  Created by Kerry Washington on 5/15/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct LockScreenHeaderView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: LockScreenHeaderViewModel
    
    init(viewModel: LockScreenHeaderViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Color
            .liteWalletDarkBlue
            .opacity(0.9)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack() {
                    Spacer()
                    Text(" 1 LTC = \(viewModel.currentValueInFiat)")
                        .font(Font(UIFont.barlowSemiBold(size: 16.0)))
                        .foregroundColor(.white)
                    
                    Text("\(S.History.currentLitecoinValue) \(viewModel.currencyCode)")
                        .font(Font(UIFont.barlowRegular(size: 14.0)))
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.bottom, 10)
                })
    }
}
 

struct LockScreenHeaderView_Previews: PreviewProvider {
 
    static let store = Store()
    static let viewModel = LockScreenHeaderViewModel(store: store)
    
    static var previews: some View {
        
        Group {
            LockScreenHeaderView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            LockScreenHeaderView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            LockScreenHeaderView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}

