import Foundation
import UIKit

fileprivate var backgroundView: UIView?

extension UIViewController {
    func showAlertInfo(_ message: String?, y: CGFloat) {
        backgroundView = UIView(frame: CGRect(x: 0, y: y, width: self.view.bounds.width * 0.855, height: 44))
        backgroundView?.center.x = self.view.center.x
        backgroundView!.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        backgroundView?.layer.cornerRadius = 22
        let alert = UILabel()
        alert.frame = backgroundView!.bounds
        alert.text = "\(message!)"
        alert.textColor = .white
        alert.textAlignment = .center
        backgroundView?.addSubview(alert)
        self.view.addSubview(backgroundView!)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 4, delay: 0) {
            backgroundView?.alpha = 0
        }
    }
    
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


