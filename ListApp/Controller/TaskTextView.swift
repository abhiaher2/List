//
//  TaskTextView.swift
//  ListApp
//
//  Created by Abhijeet Aher on 2/5/21.
//

import UIKit

class TaskTextView: UITextView {

   
    public override init(frame: CGRect, textContainer: NSTextContainer?)
    {
        super.init(frame: frame, textContainer: textContainer)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        becomeFirstResponder()
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 2.0
        
        textColor = .label
        tintColor = .label
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 12.0)
        
        autocorrectionType = .yes
        
        
    }
    
}
