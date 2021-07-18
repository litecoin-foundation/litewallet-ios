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
    
    @Binding
    var shouldShow: Bool
    
    @State
    var sliderValue: Double = 0.0
     
    //MARK: - Public Variables
    let mainPadding: CGFloat = 20.0
    
    let smallButtonSize: CGFloat = 25.0
    
    var transferAmountTo: String {
        return viewModel.walletType == .litewallet ?
            S.LitecoinCard.Transfer.amountToCard :
            S.LitecoinCard.Transfer.amountToLitewallet
    }
     
    var calculatedValue: Double {
        return viewModel.currentBalance * sliderValue
    }
    
    var remainingBalance: Double {
        return (viewModel.currentBalance -
                    (viewModel.currentBalance * sliderValue))
    }
    
    init(viewModel: TransferAmountViewModel,
         shouldShow: Binding<Bool>) {
          
        self.viewModel = viewModel
        
        _shouldShow = shouldShow
        
    }
    
    var body: some View {
        
        VStack {
            
            //Balance Amount
            HStack {
                Text(viewModel.walletType.balanceLabel + ": ")
                    .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                    .foregroundColor(Color.liteWalletBlue)
                
                Spacer()
                
                Text(String(format:"%5.4f", remainingBalance) + " Ł")
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
                
                Text(String(format:"%5.4f", calculatedValue) + " Ł")
                    .font(Font(UIFont.barlowLight(size: 18.0)))
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
                    .font(Font(UIFont.barlowLight(size: 15.0)))
                    .foregroundColor(Color.liteWalletBlue)
                    .padding(.trailing, 5.0)
                
            }
            
            //Underline view
            Divider()
              
            //Amount Slider
            Group {
                
                HStack {
                     
                    Image(systemName: "minus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: smallButtonSize,
                               height: smallButtonSize,
                               alignment: .center)
                        .foregroundColor(.liteWalletBlue)

                    Slider(value: $sliderValue, in: 0...1,
                           step: 0.01)
                        .accentColor(.liteWalletBlue)
                        .padding()
                    
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: smallButtonSize,
                               height: smallButtonSize,
                               alignment: .center)
                        .foregroundColor(.liteWalletBlue)
                }
                .padding(.bottom, 20.0)
            }
            
            //Start transfer
            Button(action: {
                
                //Transfer to Litecoin Card
                if viewModel.walletType == .litewallet {
                    
                    viewModel.transferToCard(amount:
                                                viewModel.transferAmount,
                                             address: viewModel.destinationAddress) {
                        //
                    }
                    
                }
                
                //Transfer to Litewallet
                if viewModel.walletType == .litecoinCard {
                    
                    viewModel.transferToLitewallet(amount: viewModel.transferAmount,
                                                   address: viewModel.destinationAddress) {
                        //
                    }
                }
                
            }) {
                Text(S.LitecoinCard.Transfer.startTransfer.localizedUppercase)
                    .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                    .frame(maxWidth: .infinity)
                    .padding(.all, 10.0)
                    .foregroundColor(Color(UIColor.white))
                    .background(Color(UIColor.liteWalletBlue))
                    .cornerRadius(4.0)
                
            }
            .padding(.bottom, 5.0)
            
            // Cancel
            Button(action: {
                self.shouldShow = false
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

struct TransferAmountView_Previews: PreviewProvider {
    
    static let lwPlusviewModel = TransferAmountViewModel(walletType: .litewallet,
                                                         walletStatus: .cardWalletEmpty,
                                                         litewalletBalance: 520.0,
                                                         litewalletAddress: "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe",
                                                         cardBalance: 0.0,
                                                         cardAddress: "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu")
    
    static let cardPlusviewModel = TransferAmountViewModel(walletType: .litecoinCard,
                                                           walletStatus: .litewalletEmpty,
                                                           litewalletBalance: 0.0,
                                                           litewalletAddress: "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe",
                                                           cardBalance: 0.0555,
                                                           cardAddress: "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu")
    
    static let lwlcPlusviewModel = TransferAmountViewModel(walletType: .litewallet,
                                                           walletStatus: .cardWalletEmpty,
                                                           litewalletBalance: 520.0,
                                                           litewalletAddress: "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe",
                                                           cardBalance: 0.658,
                                                           cardAddress: "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu")
    
    static var previews: some View {
        
        Group {
               
            TransferAmountView(viewModel: lwPlusviewModel,
                                   shouldShow: .constant(true))
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
            .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            TransferAmountView(viewModel: cardPlusviewModel,
                                   shouldShow: .constant(true))
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
            .previewDisplayName(DeviceType.Name.iPhone8)
            
            TransferAmountView(viewModel: lwlcPlusviewModel,
                               shouldShow: .constant(true))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            TransferAmountView(viewModel: lwlcPlusviewModel,
                                   shouldShow: .constant(true))
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
            .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}

