//
//  LitewalletIconView.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/13/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct LitewalletIconView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 11)
            .frame(width: 72.0,
                   height: 72.0,
                   alignment: .center)
            .foregroundColor(.white)
            .addBorder(Color.gray, width: 0.2, cornerRadius: 11.0)
            .shadow(color: .gray, radius:2.0, x: 3.0, y: 3.0)
            .overlay(
                
                //Litewallet Icon
                Image("coinBlueWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            )
    }
}

struct LitewalletIconView_Previews: PreviewProvider {
    static var previews: some View {
        LitewalletIconView()
    }
}
