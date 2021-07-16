//
//  TransferAmountSelectionView.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/17/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct TransferAmountSelectionView: View {
    
    let mainPadding: CGFloat = 40.0
 
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: TransferAmountSelectionViewModel
    
    @Binding
    var shouldShow: Bool
     
    @State
    var transferAmount: Double = 0.0
    
    @State
    private var transferAmountString: String = ""
    
    @State
    private var newBalance: Double = 0.0

    //MARK: - Private Variables
      
    private let walletStatus: WalletBalanceStatus
    
    private let transferWallet: WalletType
    
    init(viewModel: TransferAmountSelectionViewModel,
         litewalletBalance: Double,
         litecoinCardBalance: Double,
         transferWalletType:  WalletType,
         walletStatus: WalletBalanceStatus,
         shouldShow: Binding<Bool>) {
        
            self.walletStatus = walletStatus
            
            self.transferWallet = transferWalletType
     
            viewModel.litewalletBalance = litewalletBalance
            
            viewModel.litecoinCardBalance = litecoinCardBalance
             
            self.viewModel = viewModel
     
            _shouldShow = shouldShow
        
    }
    
    var body: some View {
        
        let binding = Binding<String>(get: {
            
            self.transferAmountString
            
        }, set: {
            
            let currentValue = $0
            
            self.transferAmountString = String(viewModel.newBalance(walletType: transferWallet, transferAmount: Double(currentValue)!))
            
            print("XXX transferAmountString: \(self.transferAmountString)")
            
            newBalance = viewModel.endingBalance(walletType: transferWallet,
                                           transferAmount: transferAmount)
            
            print("XXX newBalance: \(newBalance)")
        })
        
        VStack {
            HStack {
                Text(transferWallet.balanceLabel + ": ")
                    .font(Font(UIFont.barlowSemiBold(size: 20.0)))
                    .foregroundColor(Color.liteWalletBlue)
                Spacer()
                Text(String(viewModel.newBalance(walletType: transferWallet,
                                                 transferAmount: transferAmount)) + " Ł")
                    .font(Font(UIFont.barlowLight(size: 20.0)))
                    .foregroundColor(Color.liteWalletBlue)
            }
            
            HStack {
                Text(S.LitecoinCard.Transfer.amount + ": ")
                    .font(Font(UIFont.barlowSemiBold(size: 20.0)))
                    .foregroundColor(Color.liteWalletBlue)
                Spacer()
                 
                TextField(S.LitecoinCard.Transfer.enterAmount,
                          text: binding)
                .multilineTextAlignment(.trailing)
                .font(Font(UIFont.barlowRegular(size: 20.0)))
                .foregroundColor(Color.liteWalletBlue)
                .frame(width: 150)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1.5,
                       alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.litecoinGray)

            HStack {
                Text(transferWallet.newBalanceLabel + ": ")
                    .font(Font(UIFont.barlowSemiBold(size: 20.0)))
                    .foregroundColor(Color.liteWalletBlue)
                Spacer()
                Text(String(newBalance) + " Ł")
                    .font(Font(UIFont.barlowLight(size: 20.0)))
                    .foregroundColor(Color.liteWalletBlue)
            }
            .padding(.bottom, 50.0)
              
            //Start transfer
            Button(action: {
                //API Call to the backend
            }) {
                Text(S.LitecoinCard.Transfer.startTransfer.localizedUppercase)
                    .font(Font(UIFont.barlowSemiBold(size: 20.0)))
                    .frame(maxWidth: .infinity)
                    .padding(.all, 10.0)
                    .foregroundColor(Color(UIColor.white))
                    .background(Color(UIColor.liteWalletBlue))
                    .cornerRadius(4.0)

            }
            .padding(.bottom, 10.0)

            // Cancel
            Button(action: {
                self.shouldShow = false
            }) {
                Text(S.Button.cancel.uppercased())
                    .font(Font(UIFont.barlowSemiBold(size: 20.0)))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(UIColor.liteWalletBlue))
                    .background(Color(UIColor.white))
                    .cornerRadius(4.0)
                    .padding(.all, 10.0)
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

struct TransferAmountSelectionView_Previews: PreviewProvider {
    
    static let viewModel = TransferAmountSelectionViewModel()
    
    static var previews: some View {
        
        Group {
            VStack {
                TransferAmountSelectionView(viewModel: viewModel,
                                            litewalletBalance: 22.15219,
                                            litecoinCardBalance: 50.0,
                                            transferWalletType: .litewallet,
                                            walletStatus: .cardWalletEmpty,
                                            shouldShow: .constant(true))
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
            .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            VStack {
                TransferAmountSelectionView(viewModel: viewModel,
                                            litewalletBalance: 0.0,
                                            litecoinCardBalance: 50.0,
                                            transferWalletType: .litecoinCard,
                                            walletStatus: .litewalletEmpty,
                                            shouldShow: .constant(true))
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
            .previewDisplayName(DeviceType.Name.iPhone8)
            
            VStack {
                TransferAmountSelectionView(viewModel: viewModel,
                                            litewalletBalance: 223.22301,
                                            litecoinCardBalance: 0.0,
                                            transferWalletType: .litewallet,
                                            walletStatus: .litewalletAndCardNonZero,
                                            shouldShow: .constant(true))
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
            .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}










