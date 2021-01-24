//
//  Task+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/23/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var createdat: Date?
    @NSManaged public var taskdetail: String?
    @NSManaged public var taskid: Int64
    @NSManaged public var taskname: String?
    @NSManaged public var updatedat: Date?
    @NSManaged public var colorindex: Int64

}

extension Task : Identifiable {

}
