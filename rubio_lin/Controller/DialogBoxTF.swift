import UIKit

class DialogBoxTF: UITextField, UITextFieldDelegate {
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        let label = UILabel()
        label.text = "   "
        leftViewMode = .always
        leftView = label
        let button = UIButton()
        button.setImage(UIImage(named: "send"), for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        rightViewMode = .always
        rightView = button
        layer.cornerRadius = 18
        backgroundColor = .black
        alpha = 0.7
        attributedPlaceholder = NSAttributedString(string: NSLocalizedString("chatPlaceholder", comment: ""), attributes: [.foregroundColor : UIColor.white])
    }
        
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.width - 46, y: 0, width: 36, height: 36)
    }
    
    @objc func sendMessage(_ button: UIButton) {
        delegate?.textFieldShouldReturn?(self)
    }
}


