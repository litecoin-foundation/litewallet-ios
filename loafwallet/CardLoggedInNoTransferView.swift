//
//  CardLoggedInNoTransferView.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/18/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct CardLoggedInNoTransferView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: CardViewModel
    
    @State
    private var shouldLogout: Bool = false
    
    //MARK: - Private Variables
    private var cardBalance: Double {
        return viewModel.cardWalletDetails?.availableBalance ?? 0.0
    }
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack {
            
            //Logout button
            Button(action: {
                shouldLogout = true
                viewModel.isLoggedIn = false
                NotificationCenter.default.post(name: .LitecoinCardLogoutNotification,
                                                object: nil,
                                                userInfo: nil)
            }) {
                Text(S.LitecoinCard.logout)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           alignment: .center)
                    .font(Font(UIFont.barlowLight(size: 18.0)))
                    .foregroundColor(Color.liteWalletBlue)
                    .padding(.all, 10.0)
            }
            
                
                // PreTransfer Subview
                Group {
                    
                    // Top description
                    Text(S.LitecoinCard.cardBalance.localizedUppercase)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               alignment: .center)
                        .font(Font(UIFont.barlowBold(size: 20.0)))
                        .foregroundColor(Color(UIColor.liteWalletBlue))
                        .padding([.top,.leading,.trailing], 30.0)
                        .padding(.bottom, 20.0)
                    
                    VStack {
                        
                        // Litecoin Card Wallet balance
                        PreTransferView(viewModel:
                                            PreTransferViewModel(walletType: .litecoinCard,
                                                                 balance: cardBalance),
                                        observableWallets: ObservableWallets(store: self.viewModel.store,
                                                                             walletManager: self.viewModel.walletManager,
                                                                             cardBalance: self.cardBalance),
                                        walletType: .constant(.litecoinCard),
                                        wasTapped: .constant(false),
                                        twoFactorEnabled: false
                        )
                         
                        // 2FA description
                        Text(S.LitecoinCard.cardBalanceOnlyDescription)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   alignment: .center)
                            .font(Font(UIFont.barlowLight(size: 20.0)))
                            .foregroundColor(Color(UIColor.liteWalletBlue))
                            .padding([.top,.leading,.trailing], 30.0)
                         
                        Spacer()
                        
                    }
                    .padding(.top, 10.0)
                }
                .transition(.move(edge: .leading))
                .animation(.easeInOut(duration: 0.5))
            
            
            Spacer()
        }
    }
}

struct CardLoggedInNoTransferView_Previews: PreviewProvider {
    
    static let amount100 = MockSeeds.amount100
    
    static let walletManager = MockSeeds.walletManager
    
    static let store = Store()
    
    static let viewModel = CardViewModel(walletManager: walletManager,
                                         store: store)
    
    static var previews: some View {
        Group {
            CardLoggedInNoTransferView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            CardLoggedInNoTransferView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            CardLoggedInNoTransferView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}









