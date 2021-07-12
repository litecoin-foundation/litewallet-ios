//
//  CardLoggedInView.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/26/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct CardLoggedInView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: CardViewModel
    
    @ObservedObject
    var animatedViewModel = AnimatedCardViewModel()
    
    @State
    private var shouldLogout: Bool = false
    
    @State
    var balanceText = ""
    
    @State
    var walletBalancesStatus: WalletBalanceStatus = .litewalletAndCardEmpty
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
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
                        .font(Font(UIFont.barlowRegular(size: 18.0)))
                        .foregroundColor(Color(UIColor.liteWalletBlue))
                        .cornerRadius(8.0)
                        .padding(.all, 10)
                }
                
                
                VStack {
                    walletViewStack()
                }
                .padding(.top,geometry.size.height/3)
                .padding(.bottom, 100.0)
 
                Spacer()
            }
        }
    }
    
    func walletViewStack() -> AnyView {
        
        guard let cardBalance = viewModel.cardWalletDetails?.availableBalance else {
            return AnyView(EmptyView())
        }
        
        let litewalletBalance = viewModel.litewalletAmount.amountForLtcFormat
        
        
        
        switch viewModel.walletBalanceStatus {
            
            case .litewalletAndCardEmpty:
                return AnyView (
                    VStack {
                        PreTransferView(viewModel: PreTransferViewModel(walletType: .litecoinCard,
                                                                        balance: cardBalance))
                            .onTapGesture(perform: {
                                
                                if cardBalance != 0.0 {
                                    assertionFailure("ERROR: Internal logic for Card Balance failed")
                                }
                            })
                        
                        PreTransferView(viewModel: PreTransferViewModel(walletType: .litewallet,
                                                                        balance: litewalletBalance))
                            .onTapGesture(perform: {
                                
                                if litewalletBalance != 0.0 {
                                    assertionFailure("ERROR: Internal logic for Litewallet balance failed")
                                }
                            })
                        Spacer()
                    }
                )
            case .cardWalletEmpty:
                return AnyView(
                    VStack {
                        PreTransferView(viewModel: PreTransferViewModel(walletType: .litewallet,
                                                                        balance: litewalletBalance))
                            .onTapGesture(perform: {
                                
                            })
                        PreTransferView(viewModel: PreTransferViewModel(walletType: .litecoinCard,
                                                                        balance: cardBalance))
                            .onTapGesture(perform: {
                                
                                if cardBalance != 0.0 {
                                    assertionFailure("ERROR: Internal logic for Card Balance failed")
                                }
                                
                            })
                        Spacer()
                    }
                )
            case .litewalletEmpty:
                return AnyView(
                    VStack {
                        PreTransferView(viewModel: PreTransferViewModel(walletType: .litecoinCard,
                                                                        balance: cardBalance))
                            .onTapGesture(perform: {
                                
                            })
                        
                        PreTransferView(viewModel: PreTransferViewModel(walletType: .litewallet,
                                                                        balance: litewalletBalance))
                            .onTapGesture(perform: {
                                
                                if litewalletBalance != 0.0 {
                                    assertionFailure("ERROR: Internal logic for Litewallet balance failed")
                                }
                                
                            })
                        Spacer()
                    }
                )
            case .litewalletAndCardNonZero:
                return AnyView(
                    VStack {
                        PreTransferView(viewModel: PreTransferViewModel(walletType: .litecoinCard,
                                                                        balance: cardBalance))
                            .onTapGesture(perform: {
                                
                            })
                        
                        PreTransferView(viewModel: PreTransferViewModel(walletType: .litewallet,
                                                                        balance: litewalletBalance))
                            .onTapGesture(perform: {
                                
                            })
                        Spacer()
                    }
                )
            case .none:
                return AnyView(Spacer())
        }
    }
    
}



struct CardLoggedInView_Previews: PreviewProvider {
    
    static let amount100 = MockSeeds.amount100
    
    static let viewModel = CardViewModel(litewalletAmount: amount100)
    
    static var previews: some View {
        Group {
            CardLoggedInView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            CardLoggedInView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            CardLoggedInView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }    }
}




