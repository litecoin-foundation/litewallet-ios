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
    
    @State
    private var isDragging: Bool = false
    
    @State
    private var selectorOffset: CGFloat = 0.0
    
    @State
    private var feeIndex = 1
    
    @State
    private var currencyIndex = 0
    
    private var didTapNotes: Bool = false
     
    private var feeString: String = ""
    
    //    @Published
    //    var searchString: String = ""
    //
    //    @Published
    //    var placeholderString: String = S.Send.UnstoppableDomains.placeholder
    //
    //    @Published
    //    var isDomainResolving: Bool = false
    
    private let buttonHeight: CGFloat = 30.0
    
    private let buttonWidth: CGFloat = 60.0
    
    private let buttonFontSize: CGFloat = 16.0
   
    private let buttonFont: Font = Font(UIFont.barlowSemiBold(size: 16.0))
    
    private let fees: [String] = [FeeType.economy.description, FeeType.regular.description,FeeType.luxury.description]
    
    private let currencies: [String] = ["LTC","USD"]
    
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
                                TextField("Litecoin address", text: $viewModel.sendAddress)
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
                        .padding(.top, 14)
                        .padding(.bottom, 8)
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
                        .frame(height: 2)
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
                                    //Do UD Lookup zil, .crypto
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
                            //Link: https://unstoppabledomains.com/?ref=6897e86a35e34f1
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
                    
                    if !didTapNotes {
                        ZStack {
                            Divider()
                                .foregroundColor(Color.white)
                                .offset(y: 0.5)
                            Divider()
                        }
                    }
                    
                    Spacer()
                    
                    //MARK: Amount
                    Group {
                        VStack {
                            HStack {
                                TextField(S.Send.amountLabel, text: $viewModel.sendAmount)
                                    .onTapGesture {
                                        /// didStartEditing = true
                                        /// //ltc1qvp0ukzwh7u98vwctkudau3equ3tfsajju82ufl
                                    }
                                    .font(buttonFont)
                                    .textFieldStyle(PlainTextFieldStyle.plain)
                                    .keyboardType(.decimalPad)
                                    .disableAutocorrection(true)
                                    .frame(height: 24, alignment: .leading)
                                    .padding(.leading, 20)
                                
                                Spacer()
                                
                                CustomSegmentedPicker(preselectedIndex: $currencyIndex,
                                                      options: currencies,
                                                      selectedColor: Color.white,
                                                      inactiveColor: Color(UIColor.litecoinGray),
                                                      textColor: Color(UIColor.litecoinDarkSilver))
                                .frame(width: geometry.size.width * 0.3)
                                .padding(.trailing, 10)
                                .padding(.bottom, 10)
                                .padding(.top, 10)
                            }
                        }
                        .background(Color.white)
                        .mask (
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .padding([.top, .leading,.trailing], 10)

                        //MARK: Fee Switch
                        VStack {
                            
                            HStack {
                                Spacer()
                                
                                CustomSegmentedPicker(preselectedIndex: $feeIndex,
                                                      options: fees,
                                                      selectedColor: Color(UIColor.liteWalletBlue),
                                                      inactiveColor: Color.white,
                                                      textColor: Color.white)
                                    .padding(.leading, geometry.size.width * 0.4)
                            }
                            
                            if !didTapNotes {
                                HStack {
                                    Spacer()
                                    
                                Text("Network Fee: $0.01")
                                        .font(Font(UIFont.barlowLight(size: 12.0)))
                                        .foregroundColor(Color(UIColor.litecoinDarkSilver))
                                    .padding(.top, 1)
                                    .padding(.trailing, 3)
                                }
                            }
                        }
                        .padding(.top, 1)
                        .padding([.leading,.trailing], 10)
  
                        VStack {
                            HStack {
                                TextField("Notes: (optional)", text: $viewModel.noteString, onEditingChanged: { _ in
                                }) { 
                                }
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
                            .frame(height: 50)
                                
                        }
                        .background(Color.white)
                        .mask (
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .padding([.top, .leading,.trailing], 10)
                    }
                   
                    //MARK: Send button
                    Button(action: {
                        //Do Send
                    }) {
                        Text(S.Send.title)
                            .frame(minWidth: 0, maxWidth: .infinity)
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
                            .padding(.top, 10)
                            .padding(.bottom, 30)
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
