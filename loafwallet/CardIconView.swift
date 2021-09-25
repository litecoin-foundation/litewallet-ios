//
//  CardIconView.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/3/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI
 
struct CardIconView: View {
    
    var body: some View {
        
        Image("litecoin-front-card-border")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110,
                   height: 72,
                   alignment:
                    .center)
            .contrast(0.95)
            .shadow(radius: 1.0, x: 2.0, y: 2.0)
    }
}

struct CardIconView_Previews: PreviewProvider {
    static var previews: some View {
        CardIconView()
    }
}
