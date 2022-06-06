//
//  SendSwiftUIView.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/3/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import SwiftUI


struct SendSwiftUIView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel = SendSwiftUIViewModel()
    
    @Binding
    var isReadyToSend: Bool
    
    @State
    private var selectedFeeIndex: Int = 0
    
    @State
    private var shouldShowFeeSegment: Bool = false
    
    private var feeString: String = ""
    
    //    @Published
    //    var searchString: String = ""
    //
    //    @Published
    //    var placeholderString: String = S.Send.UnstoppableDomains.placeholder
    //
    //    @Published
    //    var isDomainResolving: Bool = false
    
    private let buttonHeight: CGFloat = 35.0
    
    private let buttonWidth: CGFloat = 60.0
    
    private let buttonFontSize: CGFloat = 14.0
    
    init(isReadyToSend: Binding<Bool>) {
        _isReadyToSend = isReadyToSend
        
        feeString = FeeType.allCases[selectedFeeIndex]
        
        print("\(feeString)")
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                
                Group {
                    Spacer()
                    
                    // Paste and Scan Buttons
                    HStack {
                        TextField(".", text: $viewModel.searchString)
                            .onTapGesture {
                                /// didStartEditing = true
                            }
                            .font(Font(UIFont.customBody(size: 14.0)))
                            .textFieldStyle(RoundedBorderTextFieldStyle.roundedBorder)
                            .keyboardType(.asciiCapable)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .frame(height: 45.0, alignment: .leading)
                            .padding()
                        
                        Spacer()
                        
                        //MARK: Paste Dest address
                        Button(action: {
                            // Paste Dest address
                        }) {
                            HStack(spacing: 10) {
                                ZStack {
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(width: buttonWidth,
                                               height: buttonHeight,
                                               alignment: .center)
                                        .foregroundColor(Color(UIColor.secondaryButton))
                                        .shadow(color:Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4)                                     .padding(.trailing, 5)
                                    
                                    Text(S.Send.pasteLabel)
                                        .frame(width: buttonWidth,
                                               height: buttonHeight,
                                               alignment: .center)
                                        .font(Font(UIFont.customMedium(size: buttonFontSize)))
                                        .foregroundColor(Color(UIColor.grayTextTint))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color(UIColor.secondaryBorder))
                                        )
                                        .padding(.trailing, 5)
                                }
                            }
                        }
                        
                        //MARK: Scan Dest Address
                        Button(action: {
                            // Scan Dest address
                        }) {
                            HStack(spacing: 10) {
                                ZStack {
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(width: buttonWidth,
                                               height: buttonHeight,
                                               alignment: .center)
                                        .foregroundColor(Color(UIColor.secondaryButton))
                                        .shadow(color:Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4)                                     .padding(.trailing, 18)
                                    
                                    Text(S.Send.scanLabel)
                                        .frame(width: buttonWidth,
                                               height: buttonHeight,
                                               alignment: .center)
                                        .font(Font(UIFont.customMedium(size: buttonFontSize)))
                                        .foregroundColor(Color(UIColor.grayTextTint))
                                        .overlay(
                                            RoundedRectangle(cornerRadius:4)
                                                .stroke(Color(UIColor.secondaryBorder))
                                        )
                                        .padding(.trailing, 18)
                                }
                            }
                        }
                    }
                    
                }
                
                Group {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.9,
                               height: 2.0,
                               alignment: .center)
                        .foregroundColor(Color(UIColor.litecoinGray))
                        .padding()
                    
                    //MARK: UD Lookup
                    VStack {
                        HStack {
                            
                            Spacer()
                            Button(action: {
                                //Do UD Lookup
                                //.onReceive(viewModel.$searchString, perform: { currentString in
                                //
                                // Description: the minmum domain length is 4 e.g.; 'a.zil'
                                // Enabling the button when the domain string is at least 4 chars long
                                //
                                // shouldDisableLookupButton = currentString.count < 4
                                //                    })
                                // .disabled(shouldDisableLookupButton)
                                
                            }) {
                                HStack(spacing: 10) {
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(width: buttonWidth,
                                                   height: buttonHeight,
                                                   alignment: .center)
                                            .foregroundColor(Color(UIColor.secondaryButton))
                                            .shadow(color:Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4)                                     .padding(.trailing, 18)
                                        
                                        Text(S.Send.UnstoppableDomains.lookup)
                                            .frame(width: buttonWidth,
                                                   height: buttonHeight,
                                                   alignment: .center)
                                            .font(Font(UIFont.customMedium(size: buttonFontSize)))
                                            .foregroundColor(Color(UIColor.grayTextTint))
                                            .overlay(
                                                RoundedRectangle(cornerRadius:4)
                                                    .stroke(Color(UIColor.secondaryBorder))
                                            )
                                            .padding(.trailing, 18)
                                    }
                                }
                            }
                        }
                        HStack {
                            
                            Spacer()
                            Text("Get your domain from:")
                                .font(Font(UIFont.customMedium(size: 14)))
                                .foregroundColor(Color(UIColor.grayTextTint))
                                .onTapGesture {
                                    UIApplication.shared.open(URL(string: "https://unstoppabledomains.com/?ref=6897e86a35e34f1")!)
                                }
                                .padding()
                            
                            //
                            //                                .padding(.bottom, 5.0)
                            //                                .padding(.top, 5.0)
                            
                            
                            Image("ud-color-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 102,
                                       height: 22,
                                       alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .onTapGesture {
                                    UIApplication.shared.open(URL(string: "https://unstoppabledomains.com/?ref=6897e86a35e34f1")!)
                                }
                                .padding()
                            
                        }
                    }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.9,
                               height: 2.0,
                               alignment: .center)
                        .foregroundColor(Color(UIColor.litecoinGray))
                        .padding()
                }
                
                Group {
                    VStack {
                        HStack {
                            Text(S.Send.amountLabel)
                                .font(Font(UIFont.barlowSemiBold(size: 17.0)))
                                .foregroundColor(Color(UIColor.litecoinDarkSilver))
                                .padding(.leading, 18)
                            
                            Spacer()
                            
                            //MARK: Amount currency
                            Button(action: {
                                //Amount
                            }) {
                                HStack(spacing: 10) {
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(width: buttonWidth,
                                                   height: buttonHeight,
                                                   alignment: .center)
                                            .foregroundColor(Color(UIColor.secondaryButton))
                                            .shadow(color:Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4)                                     .padding(.trailing, 18)
                                        
                                        
                                        // S.Symbols.currencyButtonTitle(maxDigits: store.state.maxDigits)
                                        Text(S.Symbols.currencyButtonTitle(maxDigits: 4))
                                            .frame(width: buttonWidth,
                                                   height: buttonHeight,
                                                   alignment: .center)
                                            .font(Font(UIFont.customMedium(size: buttonFontSize)))
                                            .foregroundColor(Color(UIColor.grayTextTint))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(Color(UIColor.secondaryBorder))
                                            )
                                            .padding(.trailing, 18)
                                    }
                                }
                            }
                        }
                        HStack {
                            Text("Fee rate: \(FeeType.allCases[selectedFeeIndex].description)")
                                .font(Font(UIFont.customMedium(size: buttonFontSize)))
                                .foregroundColor(Color(UIColor.grayTextTint))
                                .padding()
                            Spacer()
                        }.onTapGesture {
                            shouldShowFeeSegment.toggle()
                        }
                        
                        if shouldShowFeeSegment {
                        HStack {
                            Picker("Fee Rate", selection: $selectedFeeIndex,
                                   content: {
                                Text(FeeType.regular.abbr)
                                    .tag(FeeType.regular.hashValue)
                                Text(FeeType.economy.abbr)
                                    .tag(FeeType.economy.hashValue)
                                Text(FeeType.luxury.abbr)
                                    .tag(FeeType.luxury.hashValue)
                            })
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: geometry.size.width * 0.45)
                            .padding()
                            Spacer()
                        }
                        }
                    }
                    
                    // Custom Divider
                    Rectangle()
                        .frame(width: geometry.size.width * 0.9,
                               height: 2.0,
                               alignment: .center)
                        .foregroundColor(Color(UIColor.litecoinGray))
                        .padding()
                    
                    //MARK: Memo
                    HStack {
                        Text(S.Send.descriptionLabel)
                            .font(Font(UIFont.barlowSemiBold(size: 17.0)))
                            .foregroundColor(Color(UIColor.litecoinDarkSilver))
                            .padding(.leading, 18)
                        
                        Spacer()
                        
                        TextField("---", text: $viewModel.memoString)
                            .onTapGesture {
                            }
                            .font(Font(UIFont.customBody(size: 14.0)))
                            .keyboardType(.asciiCapable)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .frame(height: 45.0, alignment: .leading)
                            .padding()
                    }
                    
                    // Custom Divider
                    Rectangle()
                        .frame(width: geometry.size.width * 0.9,
                               height: 2.0,
                               alignment: .center)
                        .foregroundColor(Color(UIColor.litecoinGray))
                        .padding()
                    
                    Spacer()
                    
                    //MARK: Send button
                    Button(action: {
                        //Do Send
                    }) {
                        Text(S.Send.title)
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
                            .padding([.leading, .trailing], 16)
                            .padding([.top,.bottom], 44)
                    }
                    .disabled(!isReadyToSend)
                }
            }
            
        }.background(Color(UIColor.litecoinWhite))
    }
}

struct SendSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        Group {
            
            SendSwiftUIView(isReadyToSend: .constant(false))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            SendSwiftUIView(isReadyToSend: .constant(false))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            SendSwiftUIView(isReadyToSend: .constant(false))
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneXSMax))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
        }
    }
}


/////FOR MODEL/////
///
///
///
//guard !store.state.walletState.isRescanning else {
//    let alert = UIAlertController(title: S.LitewalletAlert.error, message: S.Send.isRescanning, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: S.Button.ok, style: .cancel, handler: nil))
//    topViewController?.present(alert, animated: true, completion: nil)
//    return nil
//}
//guard let walletManager = walletManager else { return nil }
//guard let kvStore = walletManager.apiClient?.kv else { return nil }
//
//
//let sendSwiftUIVC = UIHostingController(rootView: SendSwiftUIView())
//
//let bounds = UIScreen.main.bounds
//let width = bounds.size.width
//
//let modalRoot = ModalViewController(childViewController: sendSwiftUIVC, store: store, isRootSwiftUI: true)
//modalRoot.view.frame = CGRect(x: 0, y: 0, width: width, height: bounds.size.height)
//
////        let sendVC = SendViewController(store: store, sender: Sender(walletManager: walletManager, kvStore: kvStore, store: store),  walletManager: walletManager, initialRequest: currentRequest)
////        currentRequest = nil
////
////        if store.state.isLoginRequired {
////            sendVC.isPresentedFromLock = true
////        }
////
////        let root = ModalViewController(childViewController: sendSwiftUIVC, store: store)
////        sendVC.presentScan = presentScan(parent: root)
////        sendVC.presentVerifyPin = { [weak self, weak root] bodyText, callback in
////            guard let myself = self else { return }
////            let vc = VerifyPinViewController(bodyText: bodyText, pinLength: myself.store.state.pinLength, callback: callback)
////            vc.transitioningDelegate = self?.verifyPinTransitionDelegate
////            vc.modalPresentationStyle = .overFullScreen
////            vc.modalPresentationCapturesStatusBarAppearance = true
////            root?.view.isFrameChangeBlocked = true
////            root?.present(vc, animated: true, completion: nil)
////        }
////        sendVC.onPublishSuccess = { [weak self] in
////            self?.presentAlert(.sendSuccess, completion: {})
////        }
////
////        sendVC.onResolvedSuccess = { [weak self] in
////            self?.presentAlert(.resolvedSuccess, completion: {})
////        }
////
////        sendVC.onResolutionFailure = { [weak self] failureMessage in
////            self?.presentFailureAlert(.failedResolution, errorMessage: failureMessage, completion: {})
////        }


