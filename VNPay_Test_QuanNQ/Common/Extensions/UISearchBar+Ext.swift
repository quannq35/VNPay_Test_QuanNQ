//
//  UISearchBar+Ext.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 5/6/25.
//

import Foundation
import UIKit

extension UISearchBar {
    func enableSimpleInputValidation() {
        guard let textField = self.value(forKey: "searchField") as? UITextField else { return }
        let validator = SearchBarValidator.shared
        textField.delegate = validator
        textField.addTarget(validator, action: #selector(SearchBarValidator.textDidChange(_:)), for: .editingChanged)
    }
}

private class SearchBarValidator: NSObject, UITextFieldDelegate {
    static let shared = SearchBarValidator()
    @objc func textDidChange(_ textField: UITextField) {
        let allowedSpecialCharacters = "!@#$%^&*():.,<>/[]?.\\"
        let allowedCharacterSet =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 " + allowedSpecialCharacters
        
        guard let text = textField.text else { return }
                
        let filtered = text
            .folding(options: .diacriticInsensitive, locale: .current)  // Loại bỏ dấu
            .filter {$0.isASCII && ($0.isLetter || $0.isNumber || $0.isWhitespace || allowedCharacterSet.contains($0))}

        if text != filtered {
            textField.text = filtered
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.isEmpty { return true }
        let allowedSpecialCharacters = "!@#$%^&*():.,<>/[]?.\\"
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 " + allowedSpecialCharacters)
        
        let folded = string.folding(options: .diacriticInsensitive, locale: .current)
        let filtered = folded.unicodeScalars
            .filter { allowedCharacterSet.contains($0) && $0.isASCII }
            .map { Character($0) }
        
        let cleanedString = String(filtered)
        
        guard let currentText = textField.text, let textRange = Range(range, in: currentText) else { return false }
        
        var newText = currentText.replacingCharacters(in: textRange, with: cleanedString)
        
        if newText.count > 15 {
            newText = String(newText.prefix(15))
        }

        if newText != currentText {
            textField.text = newText
            textField.sendActions(for: .editingChanged)
        }
        return false
    }
}
