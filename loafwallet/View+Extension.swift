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
    
    func loginAlertView(isShowingLoginAlert: Binding<Bool>,
                        didFail: Binding<Bool>,
                        message: String) -> some View {
        loafwallet.LoginCardAlertView(isShowingLoginAlert: isShowingLoginAlert,
                                      didFail: didFail,
                                      presenting: self,
                                      mainMessage: message)
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
}
 
