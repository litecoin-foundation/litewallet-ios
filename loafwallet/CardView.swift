//
//  CardView.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/23/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI
import UIKit


struct CardView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: CardViewModel
    
    @ObservedObject
    var registrationModel = RegistrationViewModel()
    
    @ObservedObject
    var loginModel = LoginViewModel()
    
    @ObservedObject
    var animatedViewModel = AnimatedCardViewModel()
    
    @ObservedObject
    var twoFAviewModel = Enter2FACodeViewModel()
    
    @State
    private var shouldShowLoginModal: Bool = false
    
    @State
    private var didFailToLogin: Bool = false
    
    @State
    var didTapIForgot: Bool = false
    
    @State
    var didShowCardView: Bool = false
    
    @State
    var shouldShowEnable2FAModal: Bool = false
    
    @State
    private var shouldShowRegistrationView: Bool = false
    
    @State
    private var shouldShowPassword: Bool = false
    
    @State
    private var forgotEmailAddressInput = ""
    
    @State
    var didCompleteLogin: Bool = false
    
    @State
    var isEmailValid: Bool = false
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                //MARK: - Animated Card View
                Group {
                    AnimatedCardView(viewModel: animatedViewModel, isLoggedIn: $didCompleteLogin)
                        .frame(minWidth:0,
                               maxWidth:
                                didCompleteLogin ? geometry.size.width * 0.4 :
                                geometry.size.width * 0.6)
                        .padding(.all, didCompleteLogin ? 10 : 20)
                }
                
                //MARK: - Login Textfields
                Group {
                    
                    TextField(S.Receive.emailButton,
                              text: $loginModel.emailString)
                        .onReceive(loginModel.$emailString) { currentEmail in
                            if currentEmail.count < 4 ||  !registrationModel.isEmailValid(emailString: currentEmail) {
                                isEmailValid = false
                            } else {
                                isEmailValid = true
                            }
                        }
                        .foregroundColor(isEmailValid ? .black : Color(UIColor.litecoinOrange))
                        .font(Font(UIFont.barlowSemiBold(size: 17.0)))
                        .accentColor(Color(UIColor.liteWalletBlue))
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 18)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    Divider().padding([.leading, .trailing], 20)
                    
                    HStack {
                        if shouldShowPassword {
                            
                            TextField(S.Import.passwordPlaceholder.capitalized, text: $loginModel.passwordString)
                                .foregroundColor(.black)
                                .font(Font(UIFont.barlowSemiBold(size: 17.0)))
                                .accentColor(Color(UIColor.liteWalletBlue))
                                .padding(.leading, 20)
                                .padding(.top, 18)
                                .autocapitalization(.none)
                                .keyboardType(.asciiCapable)
                            
                        } else {
                            
                            SecureField(S.Import.passwordPlaceholder.capitalized, text: $loginModel.passwordString)
                                .foregroundColor(.black)
                                .font(Font(UIFont.barlowSemiBold(size: 17.0)))
                                .accentColor(Color(UIColor.liteWalletBlue))
                                .padding(.leading, 20)
                                .padding(.top, 15)
                                .autocapitalization(.none)
                                .keyboardType(.asciiCapable)
                        }
                        
                        Spacer()
                        Button(action: {
                            shouldShowPassword.toggle()
                        }) {
                            Image(systemName: shouldShowPassword ? "eye.fill" : "eye.slash.fill")
                                .padding(.top, 15)
                                .padding(.trailing, 20)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Divider().padding([.leading, .trailing], 20)
                    Spacer()
                    
                    HStack {
                        
                        Toggle("XXEnable 2FA for transfers",
                               isOn: $loginModel.shouldEnable2FA)
                            .foregroundColor(.gray)
                            .font(Font(UIFont.barlowRegular(size: 16.0)))
                            .padding([.leading, .trailing], 20)
                            .padding(.top, 10)
                        
                    }
                    
                    //MARK: - Action Buttons
                    Group {
                        
                        // Forgot password button
                        Button(action: {
                            didTapIForgot = true
                        }) {
                            
                            Text(S.LitecoinCard.forgotPassword)
                                .frame(minWidth:0, maxWidth: .infinity)
                                .font(Font(UIFont.barlowLight(size: 15)))
                                .foregroundColor(Color(UIColor.liteWalletBlue))
                                .padding(.all, 15)
                        }
                        
                        Spacer(minLength: 5)
                        
                        // Login button
                        Button(action: {
                            
                            // Description
                            // There is a two step process here:
                            // 1. Check if the user wants 2FA
                            // 2. Make discardable loginUser Call
                            // 3. Make loginUser again with the token
                            
                            if loginModel.shouldEnable2FA {
                                
                                //Discardable result API sends Code to email
                                loginModel.login { _ in }
                                
                                //Shows the 2FA Modal
                                shouldShowEnable2FAModal = true
                            }
                            else {
                                
                                //Shows the Login Modal
                                shouldShowLoginModal = true
                                
                                //Login without 2FA
                                loginModel.login { didLogin in
                                    
                                    if didLogin {
                                        
                                        viewModel.isLoggedIn = true
                                        shouldShowLoginModal = false
                                        NotificationCenter.default.post(name: .LitecoinCardLoginNotification,
                                                                        object: nil,
                                                                        userInfo: nil)
                                    } else {
                                        viewModel.isLoggedIn = true
                                        didFailToLogin = true
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                            shouldShowLoginModal = false
                                        }
                                    }
                                }
                            }
                            
                        }) {
                            
                            Text(S.LitecoinCard.login)
                                .frame(minWidth:0, maxWidth: .infinity)
                                .padding()
                                .font(Font(UIFont.barlowMedium(size: 16.0)))
                                .padding([.leading, .trailing], 16)
                                .foregroundColor(.white)
                                .background(Color(UIColor.liteWalletBlue))
                                .cornerRadius(4.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius:4)
                                        .stroke(Color(UIColor.liteWalletBlue), lineWidth: 1)
                                )
                        }
                        .padding([.leading, .trailing], 16)
                        .disabled(loginModel.simpleCredentialsCheck())
                        
                        // Registration button
                        Button(action: {
                            shouldShowRegistrationView = true
                        }) {
                            Text(S.LitecoinCard.registerCard)
                                .frame(minWidth:0, maxWidth: .infinity)
                                .padding()
                                .font(Font(UIFont.barlowMedium(size: 15.0)))
                                .foregroundColor(Color(UIColor.liteWalletBlue))
                                .overlay(
                                    RoundedRectangle(cornerRadius:4)
                                        .stroke(Color(UIColor.liteWalletBlue), lineWidth: 1)
                                )
                                .padding([.leading, .trailing], 16)
                                .padding([.top,.bottom], 10)
                        }
                        .sheet(isPresented: $shouldShowRegistrationView) {
                            RegistrationView(viewModel: registrationModel)
                        }
                    }
                    Spacer()
                }
            }.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.UIKeyboardWillShow)) { _ in
                animatedViewModel.dropOffset = -200
            }.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.UIKeyboardWillHide)) { _ in
                animatedViewModel.dropOffset = 0
            }.onReceive(twoFAviewModel.$tokenString, perform: { confirmedToken in
                
                if twoFAviewModel.didSetToken &&
                    confirmedToken.count == 6 {
                    
                    loginModel.tokenString = confirmedToken
                    shouldShowLoginModal = true
                    
                    loginModel.login { didLogin in
                        
                        if didLogin {
                            
                            viewModel.isLoggedIn = true
                            shouldShowLoginModal = false
                            
                            NotificationCenter.default.post(name: .LitecoinCardLoginNotification,
                                                            object: nil,
                                                            userInfo: nil)
                        } else {
                            
                            viewModel.isLoggedIn = true
                            didFailToLogin = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                shouldShowLoginModal = false
                            }
                        }
                    }
                }
            })
            .onAppear(){
                didShowCardView = true
            }
            .cardV1ToastView(isShowingCardToast: $didShowCardView)
            .animation(.easeOut)
            .transition(.scale)
            .forgotPasswordView(isShowingForgot: $didTapIForgot,
                                emailString: $forgotEmailAddressInput,
                                message: S.LitecoinCard.forgotPassword)
            .loginAlertView(isShowingLoginAlert: $shouldShowLoginModal,
                            didFail: $didFailToLogin,
                            message: $loginModel.processMessage)
            .registeredAlertView(shouldStartRegistering: $registrationModel.isRegistering,
                                 didRegister: $registrationModel.didRegister,
                                 data: registrationModel.dataDictionary,
                                 message: $registrationModel.message)
            .enter2FACodeView(shouldShowEnter2FAView: $shouldShowEnable2FAModal,
                              twoFAModel: twoFAviewModel)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .center)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    
    static let viewModel = CardViewModel()
    
    static var previews: some View {
        
        Group {
            CardView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            CardView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            CardView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}


