//
//  CustomSegmentedPicker.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/12/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import SwiftUI

//Inspired by: https://ishtiz.com/swift/custom-segmented-control-in-swiftui

struct CustomSegmentedPicker: View {
    
    @Binding
    var preselectedIndex: Int
    var options: [String]
    var selectedColor: Color
    var inactiveColor: Color
    var textColor: Color
 
        var body: some View {
            HStack(spacing: 0) {
                ForEach(options.indices, id:\.self) { index in
                    ZStack {
                        Rectangle()
                            .fill(inactiveColor)
 
                        Rectangle()
                            .fill(selectedColor)
                            .cornerRadius(15)
                            .padding(2)
                            .opacity(preselectedIndex == index ? 1 : 0.01)
                            .onTapGesture {
                                withAnimation(.interactiveSpring()) {
                                    preselectedIndex = index
                                }
                            }
                    }
                    .overlay(
                        Text(options[index])
                            .font(Font(UIFont.barlowSemiBold(size: 10.0)))
                            .foregroundColor(preselectedIndex == index ? textColor : Color(UIColor.litecoinSilver))
                    )
                }
            }
            .frame(height: 30)
            .cornerRadius(15)
        }
    }

struct CustomSegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedPicker(preselectedIndex: .constant(1),
                              options: ["0","1","2"],
                              selectedColor: Color.red,
                              inactiveColor: Color.gray,
                              textColor: Color.yellow)
    }
}
