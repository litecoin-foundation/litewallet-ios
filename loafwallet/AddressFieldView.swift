//
//  AddressFieldView.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/22/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI


struct AddressFieldView: UIViewRepresentable {
    
    private var placeholder: String
    
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.delegate = context.coordinator
        textfield.placeholder = placeholder
        textfield.textAlignment = .left
        textfield.adjustsFontSizeToFitWidth = true
        textfield.font = UIFont.barlowMedium(size: 14.0)
        textfield.minimumFontSize = 12.0
        textfield.keyboardType = .URL
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        return textfield
        
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: AddressFieldView
        
        init(_ textField: AddressFieldView) {
            self.parent = textField
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentValue = textField.text as NSString? {
                let proposedValue = currentValue.replacingCharacters(in: range, with: string) as String
                self.parent.text = proposedValue
            }
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            textField.resignFirstResponder()
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.parent.text = textField.text!
        }
    }
}

