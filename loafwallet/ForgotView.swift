//  ForgotAlertView.swift
//
//  Created by Kerry Washington on 12/26/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.


import SwiftUI

struct ForgotAlertView<Presenting>: View where Presenting: View {
    
    @Binding
    var isShowingForgot: Bool
    
    @Binding
    var emailString: String
    
    let presenting: Presenting
    
    var mainMessage: String
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            HStack{
                Spacer()
                ZStack {
                    self.presenting.disabled(isShowingForgot)
                    VStack {
                        Text(S.LitecoinCard.resetPassword)
                            .font(Font(UIFont.barlowBold(size: 20.0)))
                            .padding()
                            .foregroundColor(Color.white)
                        
                        Text(S.LitecoinCard.visitToReset)
                            .font(Font(UIFont.barlowMedium(size: 18.0)))
                            .foregroundColor(Color.white)
                            .padding(.all, 10)
                        
                        Divider().background(Color.white)
                        HStack {
                            Button(action: {
                                withAnimation {
                                    self.isShowingForgot.toggle()
                                }
                            }) {
                                Text(S.Button.ok)
                                    .frame(minWidth:0, maxWidth: .infinity)
                                    .padding()
                                    .font(Font(UIFont.barlowBold(size: 20.0)))
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1.5)
                    )
                    .background(Color(UIColor.liteWalletBlue))
                    .cornerRadius(8)
                    .frame(
                        width: deviceSize.size.width * 0.8,
                        height: deviceSize.size.height * 0.9
                    )
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
                    .opacity(self.isShowingForgot ? 1 : 0)
                }
                Spacer()
            }
        }
    }
}

struct ForgotAlertView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        VStack {
            Spacer()
            Text("")
                .padding(.all, 10)
                .forgotPasswordView(isShowingForgot: .constant(true), emailString: .constant("efef@sec.com"), message: "Forgot message")
            Spacer()
        }
    }
}




