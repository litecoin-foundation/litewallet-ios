//
//  PreTransferView.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/6/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct PreTransferView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: PreTransferViewModel
    
    @ObservedObject
    var observableWallets: ObservableWallets
    
    @Binding
    var wasTapped: Bool
    
    @Binding
    var walletType: WalletType
    
    //MARK: - Private Variables
    private let mainPadding: CGFloat = 20.0
    
    private let generalCornerRadius: CGFloat = 8.0
    
    private let largeHeight: CGFloat = 125.0
    
    var twoFactorEnabled: Bool = false
    
    init(viewModel: PreTransferViewModel,
         observableWallets: ObservableWallets,
         walletType: Binding<WalletType>,
         wasTapped: Binding<Bool>,
         twoFactorEnabled: Bool) {
        
        _walletType = walletType
        
        _wasTapped = wasTapped
        
        self.observableWallets = observableWallets
        
        self.viewModel = viewModel
        
        self.twoFactorEnabled = twoFactorEnabled
    }
    
    var body: some View {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: generalCornerRadius)
                        .frame(height: largeHeight,
                               alignment: .center)
                        .frame(maxWidth: .infinity)
                        .padding(mainPadding)
                        .foregroundColor(Color.litecoinGray)
                        .shadow(radius: 1.0, x: 2.0, y: 2.0)
                        .overlay(
                            
                            HStack {
                                
                                //Wallet type image & title
                                VStack(alignment: .center) {
                                    
                                    Spacer()
                                    
                                    if viewModel.walletType == .litecoinCard {
                                        CardIconView()
                                    } else {
                                        LitewalletIconView()
                                    }
                                    
                                    Text(viewModel.walletType.nameLabel)
                                        .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                                        .foregroundColor(Color.liteWalletDarkBlue)
                                       
                                    Spacer()
                                }
                                .padding(.leading, mainPadding + 12.0)
                                
                                //Balance label
                                VStack {
                                     
                                    Text(viewModel.walletType == .litecoinCard ?
                                            String(format:"%5.4f Ł", observableWallets.cardBalance) :
                                            String(format:"%5.4f Ł", observableWallets.litewalletBalance))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                        .foregroundColor(viewModel.balance == 0.0 ? .litecoinSilver : .liteWalletDarkBlue)
                                        .multilineTextAlignment(.trailing)
                                        .font(Font(twoFactorEnabled ? UIFont.barlowRegular(size: 20.0) : UIFont.barlowBold(size: 20.0)))
                                        .padding(.trailing, twoFactorEnabled ? 5.0 : 40.0)

                                }
                                
                                //Selection button
                                
                                if twoFactorEnabled {
                                VStack {
                                    
                                    Button(action: {
                                        self.walletType = viewModel.walletType
                                        self.wasTapped = true
                                    }) {
                                        
                                        ZStack {
                                            Rectangle()
                                                .frame(minHeight: 0,
                                                       maxHeight: .infinity,
                                                       alignment: .center)
                                                .frame(width: 50.0)
                                                .foregroundColor(viewModel.balance == 0.0 ? Color.litewalletLightGray : Color.liteWalletBlue)
                                                .shadow(radius: 1.0, x: 2.0, y: 2.0)
                                            
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20, alignment: .center)
                                                .foregroundColor(viewModel.balance == 0.0 ? .litecoinSilver : .white)
                                        }
                                    }
                                    .cornerRadius(generalCornerRadius, corners: [.topRight, .bottomRight])
                                    .disabled(viewModel.balance == 0.0 ? true : false)
                                }
                                .frame(height: largeHeight,
                                       alignment: .center)
                                .padding(.trailing, mainPadding)
                                
                            }
                            }
                            
                        )
                        .frame(height: largeHeight,
                               alignment: .center)
                        .frame(maxWidth: .infinity)
                }
            }
    }
}

struct PreTransferView_Previews: PreviewProvider {
    
    static let lcImagestr = MockData.cardImageString
    static let lwImagestr = MockData.logoImageString
    static let small = MockData.smallBalance
    static let large = MockData.largeBalance
    
    
    static let lcViewModel = PreTransferViewModel(walletType: .litecoinCard, balance: small)
    
    static let lwViewModel = PreTransferViewModel(walletType: .litewallet, balance: large)
    
    static let zerolcViewModel = PreTransferViewModel(walletType: .litecoinCard, balance: 0.0)
    
    static let zerolwViewModel = PreTransferViewModel(walletType: .litewallet, balance: 0.0)
    
    static let walletManager = try! WalletManager(store: Store(), dbPath: nil)
    
    static let observableWallets = ObservableWallets(store: Store(), walletManager: walletManager, cardBalance: 85.0)
 
    static var previews: some View {
        
        Group {
            VStack {
                PreTransferView(viewModel: lcViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false),
                                twoFactorEnabled: false)
                PreTransferView(viewModel: lwViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false),
                                twoFactorEnabled: true)
                PreTransferView(viewModel: zerolcViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false),
                                twoFactorEnabled: true)
                PreTransferView(viewModel: zerolwViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false),
                                twoFactorEnabled: false)
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
            .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            VStack {
                
                PreTransferView(viewModel: lcViewModel,
                                observableWallets: observableWallets,
                                 walletType: .constant(.litecoinCard),
                                 wasTapped: .constant(false),
                                 twoFactorEnabled: false)
                PreTransferView(viewModel: lwViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false),
                                twoFactorEnabled: false)
                PreTransferView(viewModel: zerolcViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false),
                                twoFactorEnabled: false)
                PreTransferView(viewModel: zerolwViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false),
                                twoFactorEnabled: false)
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
            .previewDisplayName(DeviceType.Name.iPhone8)
            
            VStack {
                
                PreTransferView(viewModel: lcViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false),
                                twoFactorEnabled: false)
                PreTransferView(viewModel: lwViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false),
                                twoFactorEnabled: false)
                PreTransferView(viewModel: zerolcViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litecoinCard),
                                wasTapped: .constant(false),
                                twoFactorEnabled: false)
                PreTransferView(viewModel: zerolwViewModel,
                                observableWallets: observableWallets,
                                walletType: .constant(.litewallet),
                                wasTapped: .constant(false),
                                twoFactorEnabled: false)
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
            .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}











