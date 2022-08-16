//
//  SendAddressCellView.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/16/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct SendAddressCellView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: SendAddressCellViewModel
      
    init(viewModel: SendAddressCellViewModel) {
        
        self.viewModel = viewModel
    }
      
    var body: some View {
        
        VStack {
            Text("XXXX")
                .font(Font(UIFont.barlowSemiBold(size: 16.0)))

        }
    }
}

struct SendAddressCellView_Previews: PreviewProvider {
     
    
    static let viewModel = SendAddressCellViewModel()
    
    static var previews: some View {
        Group {
            SendAddressCellView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            SendAddressCellView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            SendAddressCellView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}
