//
//  TaskCustomCell.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/17/21.
//

import UIKit

class TaskCustomCell: UITableViewCell {
    
    @IBOutlet var tasktext: UILabel!
    @IBOutlet var createdAt: UILabel!
    @IBOutlet var UpdatedAt: UILabel!
    @IBOutlet var taskDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
