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
                    Text(" 1 LTC = $258.00")
                        .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                        .tracking(1.1)
                        .foregroundColor(.white)
                        .padding(.bottom, 0)
                    
                    Text("Current Litecoin (LTC) value in USD")
                        .font(Font(UIFont.barlowRegular(size: 15.0)))
                        //.tracking(1.05)
                        .foregroundColor(.white)
                        .padding(.bottom, 15)
                })
    }
}
 

struct LockScreenHeaderView_Previews: PreviewProvider {
 
    static let viewModel = LockScreenHeaderViewModel()
    
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

