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
    
    @State
    private var didChangeCurrency: Bool = false
    
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
    
    private let buttonWidth: CGFloat = 65.0
    
    private let buttonFontSize: CGFloat = 16.0
   
    private let buttonFont: Font = Font(UIFont.barlowSemiBold(size: 16.0))
    
    init(isReadyToSend: Binding<Bool>) {
        _isReadyToSend = isReadyToSend
        
//        feeString = FeeType.allCases[selectedFeeIndex]
//
//        print("\(feeString)")
    }
    
    var body: some View {
        GeometryReader { geometry in
            
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.litecoinGray))
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    //MARK: Litecoin address section
                    Group {
                        
                        VStack {
                        
                            //MARK: Enter Address
                            HStack {
                                TextField("Litecoin address", text: $viewModel.searchString)
                                    .onTapGesture {
                                        /// didStartEditing = true
                                        /// //ltc1qvp0ukzwh7u98vwctkudau3equ3tfsajju82ufl
                                    }
                                    .font(buttonFont)
                                    .textFieldStyle(PlainTextFieldStyle.plain)
                                    .keyboardType(.asciiCapable)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding(.leading, 20)
                                Spacer()
                            }
                            .padding(.top, 5)
                            
                            HStack {
                                Spacer()
                                //MARK: Paste Dest address
                                Button(action: {
                                    // Paste Dest address
                                }) {
                                    HStack {
                                        ZStack {
                                            Capsule()
                                                .frame(width: buttonWidth,
                                                       height: buttonHeight,
                                                       alignment: .center)
                                                .foregroundColor(Color(UIColor.litecoinGray))
                                            
                                            Text(S.Send.pasteLabel)
                                                .frame(width: buttonWidth,
                                                       height: buttonHeight,
                                                       alignment: .center)
                                                .font(buttonFont)
                                                .foregroundColor(Color(UIColor.litecoinSilver))
                                        }
                                    }
                                }
                                
                                //MARK: Scan Dest Address
                                Button(action: {
                                    // Scan Dest address
                                }) {
                                    HStack {
                                        ZStack {
                                            
                                            Capsule()
                                                .frame(width: buttonWidth,
                                                       height: buttonHeight,
                                                       alignment: .center)
                                                .foregroundColor(Color(UIColor.litecoinGray))
                                            
                                            Text(S.Send.scanLabel)
                                                .frame(width: buttonWidth,
                                                       height: buttonHeight,
                                                       alignment: .center)
                                                .font(buttonFont)
                                                .foregroundColor(Color(UIColor.litecoinSilver))
                                        }
                                    }.padding(.trailing, 10)
                                }
                            }
                            .padding(.bottom, 10)
                        }
                        .background(Color.white)
                        .mask (
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding([.trailing,.leading], 14)
                        
                    }
                    
                    //MARK: or Section
                    Group {
                        HStack {
                            Rectangle()
                                .frame(width: 45.0,
                                       height: 1.0,
                                       alignment: .center)
                                .foregroundColor(Color(UIColor.litecoinSilver))
                                .padding(.trailing, 8.0)

                            Text(S.Fragments.or)
                                .font(buttonFont)
                                .foregroundColor(Color(UIColor.litecoinDarkSilver))

                            
                            Rectangle()
                                .frame(width: 45.0,
                                       height: 1.0,
                                       alignment: .center)
                                .foregroundColor(Color(UIColor.litecoinSilver))
                                .padding(.leading, 8.0)
                        }
                        .frame(height: 10)
                    }
           
                    //MARK: UD Section
                    Group {
                        
                        VStack {
                            
                            HStack {
                                TextField("Enter", text: $viewModel.searchString)
                                    .onTapGesture {
                                        /// didStartEditing = true
                                        /// //ltc1qvp0ukzwh7u98vwctkudau3equ3tfsajju82ufl
                                    }
                                    .font(buttonFont)
                                    .textFieldStyle(PlainTextFieldStyle.plain)
                                    .keyboardType(.asciiCapable)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .frame(height: 24, alignment: .leading)
                                    .padding(.leading, 20)
                                
                                
                                Spacer()
                                
                                //MARK: UD Lookup
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
                                    HStack {
                                        ZStack {
                                            
                                            Capsule()
                                                .frame(width: buttonWidth + 10,
                                                       height: buttonHeight,
                                                       alignment: .center)
                                                .foregroundColor(Color(UIColor.litecoinGray))
                                            
                                            Text(S.Send.UnstoppableDomains.lookup)
                                                .frame(width: buttonWidth,
                                                       height: buttonHeight,
                                                       alignment: .center)
                                                .font(buttonFont)
                                                .foregroundColor(Color(UIColor.litecoinSilver))
                                        }
                                    }.padding(.all, 10)
                                }
                            }
                        }
                        .background(Color.white)
                        .mask (
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .padding(.all, 10)
                        
                        //MARK: UD Affliate Button
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
                            HStack {
                                Spacer()
                                 Text("Get your domain from:")
                                    .font(Font(UIFont.barlowRegular(size: 16.0)))
                                    .lineSpacing(0.1)
                                    .foregroundColor(Color(UIColor.litecoinDarkSilver))
                                    .padding(.trailing, 5)
                                Image("ud-color-logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 23)
                                    .padding(.trailing, 5)
                            }
                            .padding(.trailing, 10)

                        }
                    }
                    ZStack {
                        Divider()
                            .foregroundColor(Color.white)
                            .offset(y: 0.5)
                        Divider()
                    }
                    //MARK: Amount
                    Group {
                    HStack {
                        TextField(S.Send.amountLabel, text: $viewModel.searchString)
                            .onTapGesture {
                                /// didStartEditing = true
                                /// //ltc1qvp0ukzwh7u98vwctkudau3equ3tfsajju82ufl
                            }
                            .font(buttonFont)
                            .textFieldStyle(PlainTextFieldStyle.plain)
                            .keyboardType(.asciiCapable)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .frame(height: 24, alignment: .leading)
                            .padding(.leading, 20)
                        
                        
                        Spacer()
                         
                            ZStack {
                                 
                                Capsule()
                                    .frame(width: 2 * buttonWidth,
                                           height: buttonHeight,
                                           alignment: .center)
                                    .foregroundColor(Color(UIColor.litecoinGray))
                                    .padding(.all, 10)
                                    .overlay(
                                        HStack {
                                        Text("LTC")
                                            .font(Font(UIFont.barlowRegular(size: 16.0)))
                                            .foregroundColor(Color(UIColor.litecoinDarkSilver))
                                            .padding(.leading, 30)
                                            
                                            Spacer()
                                        }
                                    )
                                 
                                Capsule()
                                    .frame(width: buttonWidth - 2,
                                           height: buttonHeight - 4,
                                           alignment: .center)
                                    .foregroundColor(Color(UIColor.white))
                                    .onTapGesture {
                                        didChangeCurrency.toggle()
                                    }
                                    .offset(x: didChangeCurrency ? 32 : -32)
                                    .overlay(
                                        Text("USD")
                                            .font(Font(UIFont.barlowRegular(size: 16.0)))
                                            .foregroundColor(Color(didChangeCurrency ? UIColor.litecoinGray : UIColor.litecoinDarkSilver))
                                            .offset(x: didChangeCurrency ? 32 : -32)
                                    )
                            }
                         
                    }
                    .background(Color.white)
                    .mask (
                        RoundedRectangle(cornerRadius: 10)
                    )
                    .padding(.all, 10)
                    }
                    
                    //MARK: Fee Switch
                    Group {
                        HStack {
                            Text("Get your domain from:")
                                .font(Font(UIFont.barlowRegular(size: 16.0)))
                                .lineSpacing(0.1)
                                .foregroundColor(Color(UIColor.litecoinDarkSilver))
                                .padding(.trailing, 5)
                            
                            Spacer()
                            
                            ZStack {
                                
                                Capsule()
                                    .frame(width: 3 * buttonWidth,
                                           height: buttonHeight,
                                           alignment: .center)
                                    .foregroundColor(Color(UIColor.litecoinGray))
                                    .background(Color.white)
                                    .padding(.all, 10)
                                    .overlay(
                                        HStack {
                                            Text(viewModel.feeType.description)
                                                .font(Font(UIFont.barlowRegular(size: 16.0)))
                                                .foregroundColor(Color(UIColor.white))
                                                .padding(.leading, 30)
                                            
                                            Spacer()
                                        }
                                    )
                                
                                Capsule()
                                    .frame(width: buttonWidth - 2,
                                           height: buttonHeight - 4,
                                           alignment: .center)
                                    .foregroundColor(Color(UIColor.liteWalletBlue))
                                    .onDrag {
                                        <#code#>
                                    }
                                    .offset(x: didChangeCurrency ? 32 : -32)
                                    .overlay(
                                        Text(viewModel.feeType.description)
                                            .font(Font(UIFont.barlowRegular(size: 16.0)))
                                            .foregroundColor(Color(didChangeCurrency ? UIColor.litecoinGray : UIColor.litecoinDarkSilver))
                                            .offset(x: didChangeCurrency ? 32 : -32)
                                    )
                            }
                            
                        }
                    }
                    
                    ZStack {
                        Divider()
                            .foregroundColor(Color.white)
                            .offset(y: 0.5)
                        Divider()
                    }
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
                            .padding([.top,.bottom], 30)
                    }
                    .disabled(!isReadyToSend)
                    
                    }
                }
            }
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


