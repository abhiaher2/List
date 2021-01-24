//
//  AddTaskViewController.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/17/21.
//

import UIKit

final class AddTaskViewController: UIViewController {
    
    private var saveData : (() -> Void)? = nil

    @IBOutlet weak var txtAddTask: UITextField!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtAddTask.attributedPlaceholder = NSAttributedString(string: "Enter task title here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtAddTask.becomeFirstResponder()
    }
    
    @IBAction func clickSave(_ sender: UIButton) {
        let randNumber = Int(arc4random_uniform(30000))

        let taskObj = Task(context: context)
        taskObj.taskname = txtAddTask.text
        taskObj.taskid = Int64(randNumber)
        
        do{
            try self.context.save()
        }
        catch{
            print("Error in storing the task")
        }
        self.dismiss(animated: true, completion: self.saveData)
        
    }
    
    func callPrev1(completionHandler:(()->Void)?) {
        
        self.saveData = completionHandler
    }
    
    
    @IBAction func clickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    deinit {
        print("called deinit from Addtask")
    }
}
