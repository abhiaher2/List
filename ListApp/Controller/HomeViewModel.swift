//
//  HomeViewModel.swift
//  ListApp
//
//  Created by Abhijeet Aher on 2/21/21.
//

import Foundation

class HomeViewModel{
    var updateDisplayUI :(() -> ())?
    
    var isShow : Bool = false {
        didSet{
            self.updateDisplayUI?()
        }
    }
}

