//
//  Enter2FACodeView.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/9/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct Enter2FACodeView<Presenting>: View where Presenting: View {

    //MARK: - Combine Variables
    @ObservedObject
    var twoFAViewModel: Enter2FACodeViewModel
    
    @Binding
    var shouldShowEnter2FAView: Bool
    
    @State
    private var disableConfirmButton: Bool = true
    
    var presenting: Presenting
    
    let tokenWidth: CGFloat = 150
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            HStack{
                Spacer(minLength: 5)
                ZStack {
                    self.presenting.disabled(shouldShowEnter2FAView)
                    VStack {
                        
                        //Dismiss button
                        Button(action: {
                            twoFAViewModel.shouldDismissView {
                                self.shouldShowEnter2FAView.toggle()
                                UIApplication.shared.endEditing()
                            }
                            
                        }) {
                            Image("whiteCross")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15,
                                       height: 15)
                        }
                        .frame(minWidth: 0,maxWidth: .infinity, alignment: .trailing)

                        Text(S.LitecoinCard.enterCode)
                            .font(Font(UIFont.barlowSemiBold(size: 21.0)))
                            .padding(.bottom, 8)
                            .foregroundColor(Color.white)
                         
                        Text(S.LitecoinCard.enterCodeDetail)
                            .font(Font(UIFont.barlowRegular(size: 19.0)))
                            .foregroundColor(Color.white)
                            .padding([.leading, .trailing], 20)

                        TextField("", text: $twoFAViewModel.tokenString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Font(UIFont.barlowLight(size: 25.0)))
                            .frame(width: tokenWidth,
                                   alignment: .center)
                            .padding(20)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .modifier(ClearButton(text: $twoFAViewModel.tokenString))
                            .onReceive(twoFAViewModel.$tokenString, perform: { token in
                                if token.count == 6 {
                                    disableConfirmButton = false
                                } else {
                                    disableConfirmButton = true
                                }
                            })
                        
                        Divider()
                            .background(Color.white)
                        
                        HStack {
                            
                            // Confirm button
                            Button(action: {
								
                                twoFAViewModel.didConfirmToken { token in
                                    
                                    twoFAViewModel.tokenString = token
                                    
                                    if twoFAViewModel.tokenString.count == 6 {
                                        
                                        twoFAViewModel.didSetToken = true
                                        
                                        shouldShowEnter2FAView = false
                                    }
                                }
                                
                            }) {
                                Text(S.Fragments.confirm.localizedUppercase)
                                    .frame(minWidth:0, maxWidth: .infinity)
                                    .padding()
                                    .font(Font(UIFont.barlowBold(size: 20.0)))
                                    .foregroundColor(disableConfirmButton ? Color.gray : Color.white)
                            }
                            .disabled(disableConfirmButton)
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1.5)
                    )
                    .background(Color(UIColor.liteWalletBlue))
                    .cornerRadius(8)
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
                    .opacity(self.shouldShowEnter2FAView ? 1 : 0)
                }
                Spacer(minLength: 5)
            }
        }
    }
}

struct Enter2FACodeView_Previews: PreviewProvider {
     
        static let twoFAModel = Enter2FACodeViewModel()
    
        static var previews: some View {
            
            Group {
                Text("")
                    .padding(.all, 10)
                    .enter2FACodeView(shouldShowEnter2FAView: .constant(true),
                                      twoFAModel: twoFAModel)
                    .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                    .previewDisplayName(DeviceType.Name.iPhoneSE2)
                
                Text("")
                    .padding(.all, 10)
                    .enter2FACodeView(shouldShowEnter2FAView: .constant(true),
                                      twoFAModel: twoFAModel)
                    .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                    .previewDisplayName(DeviceType.Name.iPhone8)
                
                Text("")
                    .padding(.all, 10)
                    .enter2FACodeView(shouldShowEnter2FAView: .constant(true),
                                      twoFAModel: twoFAModel)
                    .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                    .previewDisplayName(DeviceType.Name.iPhone12ProMax)
            }
    }
}

