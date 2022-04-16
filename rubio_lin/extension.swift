import Foundation
import UIKit

extension UIViewController {
    
    enum InputError: Error {
        case emailcount
        case passwordcount
        case isEmpty
    }
    
    func judgeInput(_ textField: UITextField) throws {
        guard textField.text!.trimmingCharacters(in: .whitespaces) != "" else {
            throw InputError.isEmpty
        }
        if textField.text!.contains("@") {
            let newtext = textField.text!.split(separator: "@")
            guard newtext[0].count <= 20 && newtext[0].count >= 4 else {
                throw InputError.emailcount
            }
        } else {
            guard textField.text!.count <= 12 && textField.text!.count >= 6 else {
                throw InputError.passwordcount
            }
        }
    }
}

extension UITextField {
    
    func setUITextField(_ textField: UITextField,_ cornerRadius: CGFloat ,_ backgroundColor: UIColor, _ alpha: CGFloat,_ borderWidth: CGFloat,_ borderColor: CGColor) {
        textField.layer.cornerRadius =  cornerRadius
        textField.backgroundColor = backgroundColor
        textField.alpha = alpha
        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = borderColor
    }
    
    func setLeftView(_ label: UILabel,_ textField: UITextField,_ text: String,_ mode: UITextField.ViewMode) {
        label.text = text
        textField.leftViewMode = mode
        textField.leftView = label
    }
}
