//
//  tskTextField.swift
//  ListApp
//
//  Created by Abhijeet Aher on 2/7/21.
//

import UIKit

class TaskTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    
    private func configure(){
        becomeFirstResponder()
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        layer.cornerRadius = 5
        layer.borderWidth = 1
        font = UIFont(name: "Georgia Bold", size: 20)
        textAlignment = .left
        autocorrectionType = .yes
        returnKeyType = .next
        placeholder = "Please enter task title here"
        setLeftPaddingPoints(5)
        setRightPaddingPoints(5)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
