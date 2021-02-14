//
//  AppManager.swift
//  ListApp
//
//  Created by Abhijeet Aher on 1/26/21.
//

import Foundation
import UIKit
class AppManager{
    
    static let AddNotes = "Tap + to create a new note"
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    static func makeAttributedString(with fullString: String, andBoldString boldString : String ) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string: fullString)
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0)]
        
        let range = (fullString as NSString).range(of: boldString)
           attributedString.addAttributes(boldFontAttribute, range: range)
           return attributedString
        
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

extension UIViewController {
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
