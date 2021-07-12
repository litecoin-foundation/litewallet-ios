//
//  PreTransferView.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/6/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct PreTransferView: View {
    
    let leadingpadding: CGFloat = 16.0
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: PreTransferViewModel
    
    @State
    var wasTapped: Bool = false
    
    init(viewModel: PreTransferViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                RoundedRectangle(cornerRadius: 12.0)
                    .frame(height: 130.0,
                           alignment: .center)
                    .frame(maxWidth: .infinity)
                    .padding([.top,.bottom,.leading], leadingpadding)
                    .padding([.trailing], 40.0)
                    .foregroundColor(Color.litecoinGray)
                    .shadow(color: wasTapped ? .clear : .gray , radius:2.0, x: 3.0, y: 3.0)
                    .overlay(
                        
                        VStack {
                            
                            HStack {
                                
                                if viewModel.walletType == .litecoinCard {
                                    
                                    Image(viewModel.walletType.description)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100,
                                               height: 72,
                                               alignment:
                                                .leading)
                                        .contrast(0.95)
                                        .shadow(radius: 2.0, x: 3.0, y: 3.0)
                                        .padding(.top, 2.0)
                                        .padding(.leading, 24.0)
                                    
                                } else {
                                    
                                    LitewalletIconView()
                                        .padding(.top, 2.0)
                                        .padding(.leading, 24.0)
                                }
                                Spacer()
                            }
                            
                            HStack {
                                
                                Text("\(viewModel.walletType.balanceLabel)")
                                    .frame(minWidth: 0,
                                           maxWidth: .infinity,
                                           alignment: .leading)
                                    .foregroundColor(.black)
                                    .font(Font(UIFont.barlowBold(size: 18.0)))
                                    .padding(.leading, 24.0)
                                
                                Text("\(viewModel.balance) Ł")
                                    .frame(minWidth: 0,
                                           maxWidth: .infinity,
                                           alignment: .leading)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .font(Font(UIFont.barlowRegular(size: 18.0)))
                                
                                Spacer()
                            }
                        }
                    )
                
                VStack {
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            print("GGGG")
                        }) {
                            Text("TRANSFER")
                                .frame(width: 120.0,
                                       height: 40.0,
                                       alignment: .center)
                                .font(Font(UIFont.barlowRegular(size: 18.0)))
                                .foregroundColor(.white)
                                .background(Color.liteWalletBlue)
                        }
                        .padding(.trailing, 40.0)
                        .padding(.top, 40.0)
                    }
                    
                    Spacer()
                }
            }

            
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
    
    static let zerolcViewModel = PreTransferViewModel(walletType: .litecoinCard, balance: 0.0)
    
    static let zerolwViewModel = PreTransferViewModel(walletType: .litewallet, balance: 0.0)
    static var previews: some View {
        
        Group {
            VStack {
                PreTransferView(viewModel: lcViewModel)
                PreTransferView(viewModel: lwViewModel)
                PreTransferView(viewModel: zerolcViewModel)
                PreTransferView(viewModel: zerolwViewModel)
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
            .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            VStack {
                PreTransferView(viewModel: lcViewModel)
                PreTransferView(viewModel: lwViewModel)
                PreTransferView(viewModel: zerolcViewModel)
                PreTransferView(viewModel: zerolwViewModel)
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
            .previewDisplayName(DeviceType.Name.iPhone8)
            
            VStack {
                PreTransferView(viewModel: lcViewModel)
                PreTransferView(viewModel: lwViewModel)
                PreTransferView(viewModel: zerolcViewModel)
                PreTransferView(viewModel: zerolwViewModel)
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
            .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}








