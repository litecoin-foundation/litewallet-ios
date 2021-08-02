//
//  TransferringModalView.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/27/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI
import Foundation
import UIKit

struct TransferringModalView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel = TransferringViewModel()
    
    @Binding
    var isShowingTransferring: Bool
    
    @Binding
    var shouldShowParent: Bool
    
    @State
    var detailMessage: String = S.LitecoinCard.resetPasswordDetail
    
    func runTransferProcess(completion: @escaping (Bool) -> Void) {
         
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            
            shouldShowParent = false
            viewModel.shouldStartTransfer = true
            
            completion(true)
        }
    }
       
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            HStack{
                Spacer()
                ZStack {
                    VStack {
                        
                        //Dismiss button
                        Button(action: {
                            viewModel.shouldDismissView {
                                self.isShowingTransferring.toggle()
                            }
                            
                        }) {
                            Image("whiteCross")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15,
                                       height: 15)
                        }
                        .frame(minWidth: 0,maxWidth: .infinity, alignment: .trailing)
                        
                        
                        //DEV: Add localization and polish the copy
                        Text("Transferring:")
                            .font(Font(UIFont.barlowSemiBold(size: 21.0)))
                            .padding(.bottom, 15)
                            .foregroundColor(Color.white)
                        
                        Text("343.00 Ł")
                            .font(Font(UIFont.barlowSemiBold(size: 21.0)))
                            .padding(.bottom, 15)
                            .foregroundColor(Color.white)
                        
                        Text("to Litecoin Card")
                            .font(Font(UIFont.barlowSemiBold(size: 21.0)))
                            .padding(.bottom, 15)
                            .foregroundColor(Color.white)
                        
                        //Dismiss button with text
                        Button(action: {
                            viewModel.shouldDismissView {
                                self.isShowingTransferring.toggle()
                            }
                        }) {
                            Text("Confirm")
                                .frame(minWidth:0, maxWidth: .infinity)
                                .font(Font(UIFont.barlowBold(size: 20.0)))
                                .foregroundColor(Color.white)
                                .padding(.all, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius:4)
                                        .stroke(Color(UIColor.white), lineWidth: 1)
                                )
                                .padding([.leading, .trailing], 20)
                                .padding([.top,.bottom], 10)
                        }.padding(.top, 15)
                        
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1.5)
                    )
                    .background(Color(UIColor.liteWalletBlue))
                    .cornerRadius(8)
                    .frame(
                        width: deviceSize.size.width * 0.9,
                        height: deviceSize.size.height * 0.95
                    )
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
                    .opacity(self.isShowingTransferring ? 1 : 0)
                    
                }
                Spacer()
            }
        }
    }
}

struct TransferringModalView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            TransferringModalView(isShowingTransferring: .constant(true), shouldShowParent: .constant(true))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            TransferringModalView(isShowingTransferring: .constant(true), shouldShowParent: .constant(true))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            TransferringModalView(isShowingTransferring: .constant(true), shouldShowParent: .constant(true))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}
