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
        self.configure(height: frame.size.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
      //  layer.borderWidth = 1.0
        frame.size.height = height
        textColor = .label
        tintColor = .label
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 16.0)
        autocorrectionType = .yes
        backgroundColor  = .clear
    }
    
}
