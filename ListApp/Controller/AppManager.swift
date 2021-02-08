//
//  AppManager.swift
//  ListApp
//
//  Created by Abhijeet Aher on 1/26/21.
//

import Foundation
import UIKit
class AppManager{
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
