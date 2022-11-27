//
//  SendButtonView.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/29/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct SendButtonView: View {
    
    //MARK: - Public Variables
    var doSendTransaction: (() -> Void)?
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Color.litecoinGray.edgesIgnoringSafeArea(.all)
                
            VStack {
                Spacer()
                Button(action: {
                    doSendTransaction?()
                }) {
                    HStack {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: geometry.size.width * 0.9, height: 45, alignment: .center)
                                .foregroundColor(Color(UIColor.liteWalletBlue))
                                .shadow(color:Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4)

                            Text(S.Send.sendLabel.localize())
                                .frame(width: geometry.size.width * 0.9, height: 45, alignment: .center)
                                .font(Font(UIFont.customMedium(size: 15.0)))
                                .foregroundColor(Color(UIColor.grayTextTint))
                                .overlay(
                                    RoundedRectangle(cornerRadius:4)
                                        .stroke(Color(UIColor.secondaryBorder))
                                )
                        }
                    }
                }
                .padding(.all, 8.0)
                Spacer()
            }
            }
        }
    }
}

struct SendButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SendButtonView()
    }
}
