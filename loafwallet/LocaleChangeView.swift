//
//  LocaleChangeView.swift
//  loafwallet
//
//  Created by Kerry Washington on 5/11/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct LocaleChangeView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: LocaleChangeViewModel
 
    init(viewModel: LocaleChangeViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            
            Text("Current Locale: \(viewModel.displayName)")
            .font(Font(UIFont.barlowSemiBold(size: 18.0)))
            .foregroundColor(.black)
            .padding(.leading, 20)
            .padding(.top, 10)

            Spacer()
        }
    }
}

struct LocaleChangeView_Previews: PreviewProvider {
    
    static let viewModel = LocaleChangeViewModel()
    
    static var previews: some View {
        
        Group {
            LocaleChangeView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            LocaleChangeView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            LocaleChangeView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}

