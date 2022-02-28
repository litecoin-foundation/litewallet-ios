//
//  UnstoppableDomainView.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/18/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct UnstoppableDomainView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: UnstoppableDomainViewModel
    
    @State
    private var didReceiveLTCfromUD: Bool = false
    
    @State
    private var shouldDisableLookupButton: Bool = true
    
    @State
    private var didStartEditing: Bool = false
    
    init(viewModel: UnstoppableDomainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                Spacer()
                HStack {
                    
                    if viewModel.isDomainResolving {
                        if #available(iOS 14.0, *) {
                            ProgressView()
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                            
                        } else {
                            ActivityIndicator(isAnimating: .constant(true), style: .large)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                        }
                    } else {
                         

                        VStack {
                            ZStack{
                            
                        Text(viewModel.placeholderString)
                            .font(Font(UIFont.customBody(size: 16.0)))
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .minimumScaleFactor(0.5)
                            .frame(minWidth: 0,  maxWidth: 245)
                            .frame(height: 55.0, alignment: .leading)
                            .foregroundColor(.gray)
                            .opacity(didStartEditing ? 0 : 1)
                               
                        TextField(".", text: $viewModel.searchString)
                                    .onTapGesture {
                                        didStartEditing = true
                                    }
                                    .font(Font(UIFont.customBody(size: 14.0)))
                                    .keyboardType(.URL)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .frame(height: 45.0, alignment: .leading)
                            } 
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 5)


                        
                    }
                    
                    Spacer()
                    Button(action: {
                        viewModel.resolveDomain()
                    }) {
                        HStack(spacing: 10) {
                            ZStack {
                                 
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: 60, height: 30, alignment: .center)
                                    .foregroundColor(Color(UIColor.secondaryButton))
                                    .shadow(color:Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4)                                     .padding(.trailing, 18)
                                
                                Text(S.Send.UnstoppableDomains.lookup)
                                    .frame(width: 60, height: 30, alignment: .center)
                                    .font(Font(UIFont.customMedium(size: 15.0)))
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
                Spacer()
                Rectangle()
                    .fill(Color(UIColor.secondaryBorder))
                    .frame(height: 1.0)
            }.padding(.leading, 20)
            
            HStack {
                Text(S.Fragments.or)
                    .frame(width: 70, height: 20, alignment: .center)
                    .font(Font(UIFont.customBody(size: 15.0)))
                    .foregroundColor(Color(UIColor.grayTextTint))
                    .background(Color.white)
                    .frame(width: 160, height: 20.0, alignment: .center)
                    .padding(.top, -50)
                    .padding(.leading, 60)
                Spacer()
            }
        }
    }
}

struct UnstoppableDomainView_Previews: PreviewProvider {
    
    static let viewModel = UnstoppableDomainViewModel()
    
    static var previews: some View {
        Group {
            UnstoppableDomainView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            UnstoppableDomainView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
                .previewDisplayName("iPhone 12 Pro Max")
        }
    }
}



