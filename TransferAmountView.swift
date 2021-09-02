//
//  TransferAmountView.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/17/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct TransferAmountView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: TransferAmountViewModel
    
    @ObservedObject
    var transferringviewModel = TransferringViewModel()
    
    @Binding
    var shouldShow: Bool
    
    @State
    private var  didStartTransferringView = false
    
    @State
    private var  shouldStartTransfer = false
    
    @State
    private var  transferAmount: Double = 0.0
    
    @Binding
    var sliderValue: Double
    
    //MARK: - Private Variables
    private let mainPadding: CGFloat = 20.0
    
    private let smallButtonSize: CGFloat = 25.0
    
    private var transferAmountTo: String {
        return viewModel.walletType == .litewallet ?
            S.LitecoinCard.Transfer.amountToCard :
            S.LitecoinCard.Transfer.amountToLitewallet
    }
    
    private var remainingCardBalance: Double {
        
        if viewModel.walletType == .litewallet {
            return abs(viewModel.cardBalance + (viewModel.currentBalance * sliderValue))
        } else {
            return abs(viewModel.cardBalance - (viewModel.currentBalance * sliderValue))
        }
    }
    
    private var remainingLitewalletBalance: Double {
        
        if viewModel.walletType == .litecoinCard {
            return abs(viewModel.litewalletBalance + (viewModel.currentBalance * sliderValue))
        } else {
            return abs(viewModel.litewalletBalance - (viewModel.currentBalance * sliderValue))
        }
    }
    
    init(viewModel: TransferAmountViewModel,
         sliderValue: Binding<Double>,
         shouldShow: Binding<Bool>) {
        
        self.viewModel = viewModel
        
        _sliderValue = sliderValue
        
        _shouldShow = shouldShow
        
    }
    
    private func increaseValue() {
        
        //Only take action when value is less than the current balance
        if (transferAmount < viewModel.currentBalance) {
            transferAmount = transferAmount + 0.001
            viewModel.transferAmount = transferAmount
            sliderValue = abs(transferAmount / viewModel.currentBalance)
        }
    }
    
    private func decreaseValue() {
        
        //Only take action when value is more than 0.001
        if transferAmount > 0.001 {
            transferAmount = transferAmount - 0.001
            viewModel.transferAmount = transferAmount
            sliderValue = abs(transferAmount / viewModel.currentBalance)
        }
    }
    
    var body: some View {
        ZStack {
            
            if didStartTransferringView {
                
                TransferringModalView(viewModel: transferringviewModel,
                                      isShowingTransferring: $didStartTransferringView,
                                      shouldStartTransfer: $shouldStartTransfer,
                                      destinationAddress: viewModel.destinationAddress,
                                      transferAmount: (viewModel.currentBalance * sliderValue),
                                      walletType: viewModel.walletType)
                    .zIndex(1)
                    .onReceive(transferringviewModel.$shouldStartTransfer) { _ in
                        
                        if transferringviewModel.shouldStartTransfer {
                            
                            //Transfer to Litecoin Card
                            if viewModel.walletType == .litewallet {
                                
                                viewModel.transferToCard(amount:
                                                            viewModel.transferAmount,
                                                         address: viewModel.destinationAddress) { didSend in
                                    
                                    didStartTransferringView = didSend
                                }
                                
                            //Transfer to Litewallet
                            } else if viewModel.walletType == .litecoinCard {
                                
                                viewModel.transferToLitewallet(amount: viewModel.transferAmount,
                                                               address: viewModel.destinationAddress) {
                                    
                                    didStartTransferringView = false
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                shouldShow = false
                            }
                        }
                    }
            }
            
            VStack {
                
                Group {
                    
                    //Litewallet Balance Amount
                    HStack {
                        Text(S.LitecoinCard.Transfer.litewalletBalance + ": ")
                            .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                            .foregroundColor(Color.liteWalletBlue)
                        
                        Spacer()
                        
                        Text(String(format:"%5.4f", remainingLitewalletBalance) + " Ł")
                            .font(Font(UIFont.barlowLight(size: 18.0)))
                            .foregroundColor(Color.liteWalletBlue)
                            .padding(.trailing, 5.0)
                    }
                    
                    //Card Balance Amount
                    HStack {
                        Text(S.LitecoinCard.cardBalance + ": ")
                            .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                            .foregroundColor(Color.liteWalletBlue)
                        
                        Spacer()
                        
                        Text(String(format:"%5.4f", remainingCardBalance) + " Ł")
                            .font(Font(UIFont.barlowLight(size: 18.0)))
                            .foregroundColor(Color.liteWalletBlue)
                            .padding(.trailing, 5.0)
                    }
                    
                    //Transfer Amount
                    HStack {
                        Text(transferAmountTo + ": ")
                            .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                            .foregroundColor(Color.liteWalletBlue)
                        
                        Spacer()
                        
                        Text(String(format:"%5.4f", viewModel.currentBalance * sliderValue) + " Ł")
                            .font(Font(UIFont.barlowBold(size: 18.0)))
                            .foregroundColor(Color.liteWalletBlue)
                            .padding(.trailing, 5.0)
                        
                    }
                    
                    //Destination Address
                    HStack {
                        Text(S.LitecoinCard.Transfer.destinationAddress + ": ")
                            .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                            .foregroundColor(Color.liteWalletBlue)
                        
                        Spacer()
                        
                        Text(viewModel.destinationAddress)
                            .font(Font(UIFont.barlowLight(size: 14.0)))
                            .foregroundColor(Color.liteWalletBlue)
                            .padding(.trailing, 5.0)
                    }
                }
                
                //Underline view
                Divider()
                
                //Amount Slider
                Group {
                    
                    HStack {
                        // Decrease value
                        Button(action: {
                            decreaseValue()
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: smallButtonSize,
                                       height: smallButtonSize,
                                       alignment: .center)
                                .foregroundColor(.liteWalletBlue)
                        }
                        .shadow(radius: 2.0, x: 2.0, y: 2.0)
                        
                        // Slider factor
                        Slider(value:  $sliderValue,
                               in: 0...1) { _ in
                            transferAmount = sliderValue * viewModel.currentBalance
                        }
                        .accentColor(.liteWalletBlue)
                        .padding()
                        
                        // Increase value
                        Button(action: {
                            increaseValue()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: smallButtonSize,
                                       height: smallButtonSize,
                                       alignment: .center)
                                .foregroundColor(.liteWalletBlue)
                        }
                        .shadow(radius: 2.0, x: 2.0, y: 2.0)
                        
                    }
                    .padding(.bottom, 20.0)
                }
                
                //Show transfer modal view
                Button(action: {
                    
                    viewModel.transferAmount = transferAmount
                    
                    didStartTransferringView = true
                    
                }) {
                    Text(S.LitecoinCard.Transfer.startTransfer.localizedUppercase)
                        .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                        .frame(maxWidth: .infinity)
                        .padding(.all, 10.0)
                        .foregroundColor(.white)
                        .background(sliderValue == 0.0 ? Color.litecoinGray : Color(UIColor.liteWalletBlue))
                        .cornerRadius(4.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.litecoinSilver)
                        )
                }
                .padding(.bottom, 5.0)
                .disabled(sliderValue == 0.0 ? true : false)
                
                
                // Cancel: Resets the slider
                Button(action: {
                    self.shouldShow = false
                    sliderValue = 0.0
                }) {
                    Text(S.Button.cancel.uppercased())
                        .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(UIColor.liteWalletBlue))
                        .background(Color(UIColor.white))
                        .cornerRadius(4.0)
                        .padding(.all,  10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.litecoinSilver)
                        )
                }
                Spacer()
                
            }
            .padding([.leading, .trailing], mainPadding)
            
            
            
        }
    }
}

struct TransferAmountView_Previews: PreviewProvider {
    
    static let walletManager = try! WalletManager(store: Store())
    
    static let lwPlusviewModel = TransferAmountViewModel(walletType: .litewallet,
                                                         litewalletBalance: 520.0,
                                                         litewalletAddress: "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe",
                                                         cardBalance: 0.0,
                                                         cardAddress: "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu",
                                                         walletManager: walletManager,
                                                         store: Store())
    
    static let lwlcPlusviewModel = TransferAmountViewModel(walletType: .litewallet,
                                                           litewalletBalance: 520.0,
                                                           litewalletAddress: "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe",
                                                           cardBalance: 0.658,
                                                           cardAddress: "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu",
                                                           walletManager: walletManager,
                                                           store: Store())
    
    static let cardPlusviewModel = TransferAmountViewModel(walletType: .litecoinCard,
                                                           litewalletBalance: 0.0,
                                                           litewalletAddress: "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe",
                                                           cardBalance: 0.0555,
                                                           cardAddress: "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu",
                                                           walletManager: walletManager,
                                                           store: Store())
    
    static var previews: some View {
        
        Group {
            
            TransferAmountView(viewModel: lwPlusviewModel,
                               sliderValue: .constant(0.5),
                               shouldShow: .constant(true))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            TransferAmountView(viewModel: cardPlusviewModel,
                               sliderValue: .constant(0.0),
                               shouldShow: .constant(true))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            TransferAmountView(viewModel: lwlcPlusviewModel,
                               sliderValue: .constant(0.5),
                               shouldShow: .constant(true))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneXSMax))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
        
        }
        
    }
}


