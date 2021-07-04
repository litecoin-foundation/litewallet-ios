//
//  CardLoggedInView.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/26/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct CardLoggedInView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: CardViewModel
    
    @ObservedObject
    var animatedViewModel = AnimatedCardViewModel()
     
    @State
    private var shouldLogout: Bool = false
    
    @State
    var balanceText = ""
      
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
 

                 
                Button(action: {
                    shouldLogout = true
                    viewModel.isLoggedIn = false
                    NotificationCenter.default.post(name: .LitecoinCardLogoutNotification,
                                                    object: nil,
                                                    userInfo: nil)

                }) {
                    Text(S.LitecoinCard.logout)
                        .frame(minWidth: 0,
                               maxWidth: geometry.size.width * 0.7,
                               alignment: .center)
                        .padding(.all, 10)
                        .font(Font(UIFont.barlowRegular(size: 18.0)))
                        .foregroundColor(Color(UIColor.liteWalletBlue))
                        .cornerRadius(8.0)
                        .padding(.all, 10)
                }
                Spacer()
                
//                //MARK: - Animated Card View
//                HStack() {
//                    AnimatedCardView(viewModel: animatedViewModel, isLoggedIn: .constant(true))
//                        .frame(minWidth:0,
//                               maxWidth: geometry.size.width * 0.4,
//                               alignment: .center)
//                        .padding(.all, 30)
//                }
//
                 
                //MARK: - Card Balance
                
//                Text(S.LitecoinCard.cardBalance)
//                    .frame(minWidth: 0,
//                           maxWidth: geometry.size.width * 0.4,
//                           alignment: .center)
//                    .padding(.top, 40)
//                    .font(Font(UIFont.barlowBold(size: 20.0)))
//                    .foregroundColor(Color(UIColor.liteWalletBlue))
//                Divider()
//                    .frame(minWidth: 0,
//                                maxWidth: geometry.size.width * 0.4,
//                                alignment: .center)
                
                VStack {
 
//                Text(balanceText)
//                    .frame(minWidth: 0,
//                           maxWidth: .infinity,
//                           alignment: .center)
//                    .padding()
//                    .font(Font(UIFont.barlowBold(size: 40.0)))
//                    .foregroundColor(Color(UIColor.darkGray))
//                    .background(Color(UIColor.white))
//                    .onReceive(viewModel.$walletDetails) { newWalletDetails in
//
//                        guard let availableBalance = newWalletDetails?.availableBalance else { return }
//                        self.balanceText = "Ł" + String(format:"%6.4f",availableBalance)
//                    }
//
                    Spacer()
                    
                    
                    
                RoundedRectangle(cornerRadius: 12.0)
                    .frame(width:.infinity,
                           height: 120.0,
                           alignment: .center)
                    .padding([.top,.bottom,.leading], 16.0)
                    .padding([.trailing], 90.0)                     .foregroundColor(Color(UIColor.litecoinGray))
                    .shadow(radius: 2.0, x: 3.0, y: 3.0)


                RoundedRectangle(cornerRadius: 12.0)
                    .frame(width:.infinity,
                           height: 120.0,
                           alignment: .center)
                    .padding([.top,.bottom,.leading], 16.0)
                    .padding([.trailing], 90.0)
                    .foregroundColor(Color(UIColor.litecoinGray))
                    .shadow(radius: 2.0, x: 3.0, y: 3.0)
                    
                    Button(action: {
                          
                    }) {
                        Image("RightArrow")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }

                Spacer()
                    
                }


            }
                 
        }
    }
}

struct CardLoggedInView_Previews: PreviewProvider {
    
    static let amount100 = MockSeeds.amount100
    
    static let viewModel = CardViewModel(litewalletAmount: amount100)
    
    static var previews: some View {
        Group {
            CardLoggedInView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            CardLoggedInView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            CardLoggedInView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }    }
}
