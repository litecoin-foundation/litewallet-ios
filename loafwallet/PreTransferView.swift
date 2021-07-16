//
//  PreTransferView.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/6/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct PreTransferView: View {
    
    let mainPadding: CGFloat = 20.0
    let generalCornerRadius: CGFloat = 8.0
    let largeHeight: CGFloat = 140.0

    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: PreTransferViewModel
    
    @Binding
    var wasTapped: Bool
    
    @Binding
    var walletType: WalletType
    
    init(viewModel: PreTransferViewModel,
         walletType: Binding<WalletType>,
         wasTapped: Binding<Bool>) {
        
        _walletType = walletType
        
        _wasTapped = wasTapped
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                RoundedRectangle(cornerRadius: generalCornerRadius)
                    .frame(height: largeHeight,
                           alignment: .center)
                    .frame(maxWidth: .infinity)
                    .padding(mainPadding)
                    .foregroundColor(Color.litecoinGray)
                    .shadow(radius: 2.0, x: 3.0, y: 3.0)
                    .overlay(
                        HStack {
                            
                            VStack(alignment: .center) {
                                Spacer()
                                if viewModel.walletType == .litecoinCard {
                                    
                                    Image(viewModel.walletType.description)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 110,
                                               height: 72,
                                               alignment:
                                                .center)
                                        .contrast(0.95)
                                        .shadow(color: .gray, radius:2.0, x: 3.0, y: 3.0)
                                        .padding([.top,.bottom], 2.0)
 
                                } else {
                                    
                                    LitewalletIconView()
                                        .padding([.top,.bottom], 2.0)
                                }
                                
                                Text(viewModel.walletType == .litecoinCard ? "Litecoin Card" : "Litewallet")
                                    .font(Font(UIFont.barlowSemiBold(size: 20.0)))
                                    .foregroundColor(Color.liteWalletDarkBlue)
                                
                                Spacer()
                            }
                            .padding(.leading, mainPadding + 12.0)
                            
                            VStack {
                                
                                Text("\(viewModel.balance) Ł")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                    .foregroundColor(viewModel.balance == 0.0 ? .litecoinSilver : .liteWalletDarkBlue)
                                    .multilineTextAlignment(.trailing)
                                    .font(Font(UIFont.barlowRegular(size: 20.0)))
                                    .padding(.trailing, 5.0)
                            }
                            
                            Spacer()
                            VStack {
                                Button(action: {
                                    
                                    self.wasTapped = true
                                    
                                    self.walletType = viewModel.walletType
                                    
                                }) {
                                    
                                    ZStack {
                                        
                                        Rectangle()
                                            .frame(minHeight: 0,
                                                   maxHeight: .infinity,
                                                   alignment: .center)
                                            .frame(width: 50.0)
                                            .foregroundColor(viewModel.balance == 0.0 ? Color.litewalletLightGray : Color.liteWalletBlue)
                                            .shadow(radius: 2.0, x: 3.0, y: 3.0)
                                        
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .foregroundColor(viewModel.balance == 0.0 ? .litecoinSilver : .white)
                                    }
                                }
                                .cornerRadius(generalCornerRadius, corners: [.topRight, .bottomRight])
                                .disabled(viewModel.balance == 0.0 ? true : false)
                            }
                            .frame(height: largeHeight,
                                   alignment: .center)
                            .padding(.trailing, mainPadding)

                        }
                        
                    )
                    .frame(height: largeHeight,
                           alignment: .center)
                    .frame(maxWidth: .infinity)
                    .padding(mainPadding)
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
                
                PreTransferView(viewModel: lcViewModel,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false))
                PreTransferView(viewModel: lwViewModel,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false))
                PreTransferView(viewModel: zerolcViewModel,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false))
                PreTransferView(viewModel: zerolwViewModel,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false))
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
            .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            VStack {
                
                PreTransferView(viewModel: lcViewModel,
                                 walletType: .constant(.litecoinCard),
                                 wasTapped: .constant(false))
                PreTransferView(viewModel: lwViewModel,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false))
                PreTransferView(viewModel: zerolcViewModel,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false))
                PreTransferView(viewModel: zerolwViewModel,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false))
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
            .previewDisplayName(DeviceType.Name.iPhone8)
            
            VStack {
                
                PreTransferView(viewModel: lcViewModel,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false))
                PreTransferView(viewModel: lwViewModel,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false))
                PreTransferView(viewModel: zerolcViewModel,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false))
                PreTransferView(viewModel: zerolwViewModel,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false))
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
            .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}











