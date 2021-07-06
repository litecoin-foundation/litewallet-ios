//
//  PreTransferView.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/6/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct PreTransferView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: PreTransferViewModel
    
    init(viewModel: PreTransferViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            RoundedRectangle(cornerRadius: 12.0)
                .frame(width:.infinity,
                       height: 140.0,
                       alignment: .center)
                .padding([.top,.bottom,.leading], 16.0)
                .padding([.trailing], 90.0)                     .foregroundColor(Color(UIColor.litecoinGray))
                .shadow(radius: 2.0, x: 3.0, y: 3.0)
                .overlay(
                    VStack {
                        
                        HStack {
                            
                            if viewModel.walletType == .litecoinCard {
                                
                                Image(viewModel.walletType.description)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120,
                                           height: 90,
                                           alignment:
                                            .leading)
                                    .shadow(radius: 2.0, x: 3.0, y: 3.0)
                                    .padding(.top, 10.0)
                                    .padding(.leading, 24.0)
                                
                            } else {
                                RoundedRectangle(cornerRadius: 11)
                                    .frame(width:72.0,
                                           height: 72.0,
                                           alignment: .center)
                                    .padding(.top, 10.0)
                                    .padding(.leading, 24.0)                    .foregroundColor(.white)
                                    .shadow(radius: 2.0, x: 3.0, y: 3.0)
                                    .overlay(
                                        Image(viewModel.walletType.description)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60,
                                                   height: 60)
                                            .padding(.leading, 22.0)
                                            .padding(.top, 12.0)

                                    )

                            }
                            Spacer()
                        }
                        
                        HStack{
                            
                            Text("\(viewModel.walletType.balanceLabel) ")
                                .frame(width: .infinity, height: 25, alignment: .leading)
                                .foregroundColor(.black)
                                .font(Font(UIFont.barlowBold(size: 18.0)))
                                .padding(.leading, 24.0)
                                .padding(.bottom, viewModel.walletType == .litecoinCard ? 10.0 : 4.0)
                                .padding(.trailing, 2.0)
                            
                            Text("\(viewModel.balance) Ł")
                                .frame(width: .infinity, height: 25, alignment: .leading)
                                .foregroundColor(.black)
                                .font(Font(UIFont.barlowRegular(size: 18.0)))
                                .padding(.leading, 2.0)
                                .padding(.bottom, viewModel.walletType == .litecoinCard ? 10.0 : 4.0)
                            
                            Spacer()
                        }
                        
                        
                    }
                )
        }
    }
}

struct PreTransferView_Previews: PreviewProvider {
    
    static let lcImagestr = MockData.cardImageString
    static let lwImagestr = MockData.logoImageString
    static let small = MockData.smallBalance
    static let large = MockData.largeBalance
    
    static let lcViewModel = PreTransferViewModel(walletType: .litecoinCard, balance: small)
    
    static let lwViewModel = PreTransferViewModel(walletType: .litewallet, balance: large)
    
    static var previews: some View {
        
        Group {
            VStack {
                PreTransferView(viewModel: lcViewModel)
                PreTransferView(viewModel: lwViewModel)
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
            .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            VStack {
                PreTransferView(viewModel: lcViewModel)
                PreTransferView(viewModel: lwViewModel)
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
            .previewDisplayName(DeviceType.Name.iPhone8)
            
            VStack {
                PreTransferView(viewModel: lcViewModel)
                PreTransferView(viewModel: lwViewModel)
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
            .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}







