//
//  SendSwiftUIView.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/3/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct SendSwiftUIView: View {
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack {
                Text("Hello, World!").padding()
                Text("Hello, World!").padding()
                Text("Hello, World!").padding()
                Text("Hello, World!").padding()
                Text("Hello, World!").padding()

            }.frame(height: 300)
        }
    }
}

struct SendSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SendSwiftUIView()
    }
}
