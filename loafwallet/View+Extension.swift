//
//  View+Extension.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/26/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI


extension View {
     
    /// Login Alert View
    /// - Parameters:
    ///   - isShowingLoginAlert: Shown when user is waiting to login
    ///   - didFail: failed to login (false)
    ///   - message: Error message
    /// - Returns: a constructed View
    func loginAlertView(isShowingLoginAlert: Binding<Bool>,
                        didFail: Binding<Bool>,
                        message: Binding<String>) -> some View {
        loafwallet.LoginCardAlertView(isShowingLoginAlert: isShowingLoginAlert,
                                      didFail: didFail,
                                      mainMessage: message,
                                      presenting: self)
    }
    
    func forgotPasswordView(isShowingForgot: Binding<Bool>,
                            emailString: Binding<String>,
                            message: String) -> some View {
        loafwallet.ForgotAlertView(isShowingForgot: isShowingForgot,
                                   emailString: emailString,
                                   presenting: self,
                                   mainMessage: message)
    }
    
    func registeredAlertView(shouldStartRegistering: Binding<Bool>,
                             didRegister: Binding<Bool>,
                             data: [String: Any],
                        message: Binding<String>) -> some View {
        loafwallet.RegistrationAlertView(shouldStartRegistering: shouldStartRegistering,
                                         didRegister: didRegister,
                                         mainMessage: message,
                                         presenting: self)
    }
    
    func cardV1ToastView(isShowingCardToast: Binding<Bool>) -> some View {
        loafwallet.CardV1ToastView(isShowingCardToast: isShowingCardToast,
                                   presenting: self)
    }
    
    func enter2FACodeView(shouldShowEnter2FAView: Binding<Bool>,
                          twoFAModel: Enter2FACodeViewModel) -> some View {
        loafwallet.Enter2FACodeView(twoFAViewModel: twoFAModel,
                                    shouldShowEnter2FAView: shouldShowEnter2FAView,
                                    presenting: self)
    }
}
 
//https://stackoverflow.com/questions/58200555/swiftui-add-clearbutton-to-textfield
struct ClearButton: ViewModifier {
    
    @Binding var text: String
    
    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content
            
            if !text.isEmpty
            {
                Button(action:
                        {
                            self.text = ""
                        })
                {
                    Image(systemName: "delete.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 30)
                .padding(.top, 2)
            }
        }
    }
}
