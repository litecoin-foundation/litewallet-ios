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
    
    @ObservedObject
    var transferViewModel = TransferAmountSelectionViewModel()
    
    @State
    private var shouldLogout: Bool = false
    
    @State
    private var didStartTransfer: Bool = false
    
    @State
    var walletStatus: WalletBalanceStatus = .litewalletAndCardEmpty
    
    @State
    var currentWalletType: WalletType = .litewallet
    
    private var litewalletBalance: Double {
        return viewModel.litewalletAmount.amountForLtcFormat
    }
    
    private var cardBalance: Double {
        return viewModel.cardWalletDetails?.availableBalance ?? 0.0
    }
    
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
                        .font(Font(UIFont.barlowSemiBold(size: 22.0)))
                        .foregroundColor(Color(UIColor.liteWalletBlue))
                        .cornerRadius(8.0)
                        .padding(.all, 50.0)
                }
                
                if didStartTransfer {
                    
                    Group {
                        
                        VStack {
                            TransferAmountSelectionView(viewModel: transferViewModel,
                                                        litewalletBalance: litewalletBalance,
                                                        litecoinCardBalance: cardBalance,
                                                        transferWalletType: currentWalletType,
                                                        walletStatus: walletStatus,
                                                        shouldShow: $didStartTransfer)
                            Spacer()
                        }
                        .padding(.top, 30.0)
                    }
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 0.5))
                      
                } else {
                    
                    Group {
                        
                        Text(viewModel.walletBalanceStatus == .litewalletAndCardEmpty ? "" : S.LitecoinCard.Transfer.description)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   alignment: .center)
                            .font(Font(UIFont.barlowLight(size: 26.0)))
                            .foregroundColor(Color(UIColor.liteWalletBlue))
                            .padding([.top,.leading,.trailing], 50)
                            .padding(.bottom, 10)
                        
                        VStack {
                            walletViewStack()
                            Spacer()
                        }
                        .padding(.top, 30.0)
                    }
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.5))
                }
 
                Spacer()
                
                pagingIndicatorView()
            }
        }
    }
    
    func walletViewStack() -> AnyView {
        
        switch viewModel.walletBalanceStatus {
            
            case .litewalletAndCardEmpty:
                return AnyView (
                    
                    VStack {
                        
                        PreTransferView(viewModel:
                                            PreTransferViewModel(walletType: .litecoinCard,
                                                                 balance: cardBalance),
                                                                walletType: $currentWalletType,
                                                                wasTapped: $didStartTransfer
                        ).padding(.bottom, 10.0)
                        
                        PreTransferView(viewModel:
                                            PreTransferViewModel(walletType: .litewallet,
                                                                 balance: litewalletBalance),
                                        walletType: $currentWalletType,
                                        wasTapped: $didStartTransfer
                        )
                        
                        Spacer()
                        
                    }
                )
            case .cardWalletEmpty:
                return AnyView(
                    VStack {
                        
                        PreTransferView(viewModel:
                                            PreTransferViewModel(walletType: .litewallet,
                                                                 balance: litewalletBalance),
                                                                walletType: $currentWalletType,
                                                                wasTapped: $didStartTransfer
                        ).padding(.bottom, 10.0)
                        
                        PreTransferView(viewModel:
                                            PreTransferViewModel(walletType: .litecoinCard,
                                                                 balance: cardBalance),
                                                                walletType: $currentWalletType,
                                                                wasTapped: $didStartTransfer
                        )
                        
                        Spacer()
                    }
                )
            case .litewalletEmpty:
                return AnyView(
                    VStack {
                          
                        PreTransferView(viewModel:
                                            PreTransferViewModel(walletType: .litecoinCard,
                                                                 balance: cardBalance),
                                                                walletType: $currentWalletType,
                                                                wasTapped: $didStartTransfer
                        ).padding(.bottom, 10.0)
                        
                        PreTransferView(viewModel:
                                            PreTransferViewModel(walletType: .litewallet,
                                                                 balance: litewalletBalance),
                                                                walletType: $currentWalletType,
                                                                wasTapped: $didStartTransfer
                        )
                        
                        Spacer()
                        
                    }
                )
            case .litewalletAndCardNonZero:
                return AnyView(
                    VStack {
                        
                        PreTransferView(viewModel:
                                            PreTransferViewModel(walletType: .litecoinCard,
                                                                 balance: cardBalance),
                                        walletType: $currentWalletType,
                                        wasTapped: $didStartTransfer
                        ).padding(.bottom, 10.0)
                        
                        PreTransferView(viewModel:
                                            PreTransferViewModel(walletType: .litewallet,
                                                                 balance: litewalletBalance),
                                        walletType: $currentWalletType,
                                        wasTapped: $didStartTransfer
                        )
                         
                        Spacer()
                    }
                )
            case .none:
                return AnyView(Spacer())
        }
    }
    
    func pagingIndicatorView() -> AnyView {
        
        return AnyView (
            HStack {
                Ellipse()
                    .fill(didStartTransfer ? Color.litecoinGray : .liteWalletBlue)
                    .frame(width: 10, height: 10)
                Ellipse()
                    .fill(didStartTransfer ? Color.liteWalletBlue : .litecoinGray)
                    .frame(width: 10, height: 10)
            }
            .padding(.all, 40.0)
        )
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





