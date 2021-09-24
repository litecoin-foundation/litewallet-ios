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
<<<<<<< HEAD
    var twoFactor: CardTwoFactor
    
=======
    var animatedViewModel = AnimatedCardViewModel()
     
>>>>>>> main
    @State
    private var shouldLogout: Bool = false
    
    @State
<<<<<<< HEAD
    private var didStartTransfer: Bool = false
    
    @State
    private var startingSliderValue: Double = 0.0
    
    @State
    var currentWalletType: WalletType = .litewallet
      
    //MARK: - Private Variables
    private var litewalletAddress: String {
        guard let address = viewModel
                .walletManager
                .wallet?
                .receiveAddress else {
            print("Card Logged In ViewModel ERROR: No address found")
            return ""
        }
        return address
    }
    
    private var cardBalance: Double {
        return viewModel.cardWalletDetails?.availableBalance ?? 0.0
    }
    
    private var cardAddress: String {
        return viewModel.cardWalletDetails?.ltcAddress ?? ""
    }
    
    init(viewModel: CardViewModel,
         twoFactor: CardTwoFactor
        ) {
          
        self.viewModel = viewModel
        
        self.twoFactor = twoFactor
    }
    
    /// RYO Paging Indicator: Listens to a state and updates the dots accordingly
    /// - Returns: The dots view
    private func pagingIndicatorView() -> AnyView {
        
        return AnyView (
            HStack {
                Ellipse()
                    .fill(didStartTransfer ?
                            Color.litecoinGray :
                            .liteWalletBlue)
                    .frame(width: 10,
                           height: 10)
                Ellipse()
                    .fill(didStartTransfer ?
                            Color.liteWalletBlue :
                            .litecoinGray)
                    .frame(width: 10,
                           height: 10)
            }
            .padding(.all, 10.0)
        )
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
                    .font(Font(UIFont.barlowLight(size: 19.0)))
                    .foregroundColor(Color.liteWalletBlue)
                    .padding(.all, 15.0)
            }
            
            Divider()
            
            if twoFactor.isEnabled {
            
                //Sets phase 1 or 2 of transfer
                if didStartTransfer {
                    
                        // Transfer Amount Subview
                        Group {
                            
                            Text(S.LitecoinCard.Transfer.setAmount + ": ")
                                .frame(minWidth: 0,
                                       maxWidth: .infinity,
                                       alignment: .center)
                                .font(Font(UIFont.barlowSemiBold(size: 20.0)))
                                .foregroundColor(Color(UIColor.liteWalletBlue))
                                .padding([.top,.leading,.trailing], 5.0)
                                .padding(.bottom, 2.0)
                            
                            VStack {
                                TransferAmountView(viewModel:
                                                    TransferAmountViewModel(walletType: currentWalletType,
                                                                            litewalletBalance: viewModel.litewalletBalance,
                                                                            litewalletAddress: litewalletAddress,
                                                                            cardBalance: cardBalance,
                                                                            cardAddress: cardAddress,
                                                                            walletManager: viewModel.walletManager,
                                                                            store: viewModel.store),
                                                   sliderValue: $startingSliderValue,
                                                   shouldShow: $didStartTransfer)
                                Spacer()
                            }
                            .padding(.top, 10.0)
                        }
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.5))
                        
                    }
                    else {
                        
                        // PreTransfer Subview
                        Group {
                            
                            // Top description
                            Text(S.LitecoinCard.Transfer.description)
                                .frame(minWidth: 0,
                                       maxWidth: .infinity,
                                       alignment: .center)
                                .font(Font(UIFont.barlowSemiBold(size: 20.0)))
                                .foregroundColor(Color(UIColor.liteWalletBlue))
                                .padding([.top,.leading,.trailing], 5.0)
                                .padding(.bottom, 2.0)
                            
                            VStack {
                                
                                Spacer()
                                
                                // Litewallet balance view
                                PreTransferView(walletBalance: viewModel.litewalletBalance,
                                                parentWalletType: $currentWalletType,
                                                localWalletType: .litewallet,
                                                wasTapped: $didStartTransfer,
                                                twoFactorEnabled: twoFactor.isEnabled
                                ).padding(.bottom, 10.0)
                                
                                // Litecoin Card balance view
                                //DEV: Need to get information back from Ternio
                                // Currently, to withdraw call requires 2FA *again* after logging in
                                // This currently causes an 403
                                // When Ternio provide a good process, we will add it.
                                PreTransferView(walletBalance: cardBalance,
                                                parentWalletType: $currentWalletType,
                                                localWalletType: .litecoinCard,
                                                wasTapped: $didStartTransfer,
                                                twoFactorEnabled: false //twoFactor.isEnabled - See DEV Note.
                                ).padding(.top, 10.0)
                                 
                                Spacer()
                                
                            }
                            .padding(.top, 10.0)
                        }
                        .transition(.move(edge: .leading))
                        .animation(.easeInOut(duration: 0.5))
                    }
                    
                Spacer()
                
                pagingIndicatorView()
                    .padding()
            }
            else {
                
                // Shown when the user does not have 2FA Enabled
                Group {
                    
                    VStack {
                        
                        Spacer()
                        
                        //Card No Transfer view
                        CardNoTransferView(viewModel: viewModel)
                            .padding(.bottom, 10.0)
                        
                        Spacer()
                        
                    }
                }
                .transition(.move(edge: .leading))
                .animation(.easeInOut(duration: 0.5))
            }
=======
    var balanceText = ""
      
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
 
                //MARK: - Animated Card View
                HStack() {
                    AnimatedCardView(viewModel: animatedViewModel, isLoggedIn: .constant(true))
                        .frame(minWidth:0,
                               maxWidth: geometry.size.width * 0.4,
                               alignment: .center)
                        .padding(.all, 30)
                }
                 
                Button(action: {
                    shouldLogout = true
                    viewModel.isLoggedIn = false
                    NotificationCenter.default.post(name: .LitecoinCardLogoutNotification,
                                                    object: nil,
                                                    userInfo: nil)

                }) {
                    Text(S.LitecoinCard.logout)
                        .frame(minWidth: 0,
                               maxWidth: geometry.size.width * 0.7,
                               alignment: .center)
                        .padding(.all, 10)
                        .font(Font(UIFont.barlowRegular(size: 18.0)))
                        .foregroundColor(Color(UIColor.liteWalletBlue))
                        .cornerRadius(8.0)
                        .padding(.all, 10)
                }
                 
                //MARK: - Card Balance
                
                Text(S.LitecoinCard.cardBalance)
                    .frame(minWidth: 0,
                           maxWidth: geometry.size.width * 0.4,
                           alignment: .center)
                    .padding(.top, 40)
                    .font(Font(UIFont.barlowBold(size: 20.0)))
                    .foregroundColor(Color(UIColor.liteWalletBlue))
                Divider()
                    .frame(minWidth: 0,
                                maxWidth: geometry.size.width * 0.4,
                                alignment: .center)
                
                Text(balanceText)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           alignment: .center)
                    .padding()
                    .font(Font(UIFont.barlowBold(size: 40.0)))
                    .foregroundColor(Color(UIColor.darkGray))
                    .background(Color(UIColor.white))
                    .onReceive(viewModel.$walletDetails) { newWalletDetails in
                        
                        guard let availableBalance = newWalletDetails?.availableBalance else { return }
                        self.balanceText = "Ł" + String(format:"%6.4f",availableBalance)
                    }
                
                Spacer()
            }
                 
>>>>>>> main
        }
    }
}

struct CardLoggedInView_Previews: PreviewProvider {
    
<<<<<<< HEAD
    static let amount100 = MockSeeds.amount100
    
    static let walletManager = MockSeeds.walletManager
    
    static let store = Store()
    
    static let viewModel = CardViewModel(walletManager: walletManager,
                                         store: store)
    
    static let twoFactor = CardTwoFactor()
    
    static var previews: some View {
        Group {
            CardLoggedInView(viewModel: viewModel, twoFactor: twoFactor)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            CardLoggedInView(viewModel: viewModel, twoFactor: twoFactor)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            CardLoggedInView(viewModel: viewModel, twoFactor: twoFactor)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}













=======
    static let viewModel = CardViewModel()
    
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
>>>>>>> main
