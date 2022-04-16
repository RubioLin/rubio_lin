import Foundation
import UIKit

fileprivate var backgroundView: UIView?

extension UIViewController {
    
    func showSpinner() {
        backgroundView = UIView(frame: self.view.bounds)
        backgroundView!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = backgroundView!.center
        activityIndicator.startAnimating()
        backgroundView!.addSubview(activityIndicator)
        self.view.addSubview(backgroundView!)
    }
    
    func removeSpinner() {
        backgroundView?.removeFromSuperview()
        print("有喔")
    }
    
    
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
