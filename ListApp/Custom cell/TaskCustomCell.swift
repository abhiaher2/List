//
//  TaskCustomCell.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/17/21.
//

import UIKit

class TaskCustomCell: UITableViewCell {
    
    static let reuseId = "Cell"
    
    @IBOutlet var tasktext: UILabel!
    @IBOutlet var createdAt: UILabel!
    @IBOutlet var UpdatedAt: UILabel!
    @IBOutlet var taskDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
     func set(taskObj: Task){
        
        self.tasktext.text = taskObj.taskname
        self.taskDetail.text = taskObj.taskdetail
        self.UpdatedAt.text = "\(self.getDateInString(date:taskObj.updatedat!))"
        self.backgroundColor = CustomColor.getColor(colorIndex: Int(taskObj.colorindex))
    }
    
    private func getDateInString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, hh:mm a"
        return formatter.string(from: date)
    }

}
