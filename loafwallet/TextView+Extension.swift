//
//  TextView+Extension.swift
//  loafwallet
//
//  Created by Kerry Washington on 3/12/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

//https://stackoverflow.com/questions/65297333/adding-placeholder-to-uitextview-in-swiftui-uiviewrepresentable

struct TextView: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var didStartEditing: Bool
    private var placeholder: String
    
    init(text: Binding<String>,
         didStartEditing: Binding<Bool>,
        placeholderString: String) {
        
        self._text = text
        self._didStartEditing = didStartEditing
        self.placeholder = placeholderString
    }
    let udModel = UnstoppableDomainViewModel()
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView() 
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.font = .customBody(size: 6.0)
         
        return textView
    }
    
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        if didStartEditing {
            
            uiView.textColor = UIColor.black
            uiView.text = text
            
        }
        else {
            uiView.text = self.placeholder
            uiView.textColor = UIColor.lightGray
            uiView.font = .customBody(size: 6.0)
        }
        
        uiView.font = UIFont.preferredFont(forTextStyle: .body)
        
    }
}
