//
//  TaskDetailViewController.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/17/21.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {
   
   // private var saveData : (() -> Void)? = nil

    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var txtVw: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    var  button : UIButton?
    var taskId : Int?
    var note: [Task]?
    var selectedColorIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpNavigationBar()

        guard self.taskId != nil else {return}
        self.getTask()
    }
    
    private func setUpNavigationBar(){
        let doneButton   = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickDoneButton))
    
        button = UIButton(type: .custom)
        button!.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button!.backgroundColor = UIColor.red
        button!.addTarget(self, action: #selector(clickChooseColor), for: .touchUpInside)
        
        let item = UIBarButtonItem(customView: button!)
        navigationItem.rightBarButtonItems = [ doneButton,item]
    }
    
    @objc private func clickChooseColor(){
       let vc =  self.storyboard?.instantiateViewController(withIdentifier: "ChooseColorVC") as! ChooseColorViewController
        
   //     vc.setColor(completion: updateColor)
        vc.selectedColor = { (index) in
        self.button?.backgroundColor = CustomColor.getColor(colorIndex: index!)
        self.view.backgroundColor = CustomColor.getColor(colorIndex: index!)
            self.selectedColorIndex = index!
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    private func updateColor(index: Int?){
        button?.backgroundColor = CustomColor.getColor(colorIndex: index!)
        self.view.backgroundColor = CustomColor.getColor(colorIndex: index!)
    }
    
    /*-------------------------------------------------------------------------------------------*/
    private func getTask(){
        
        do{
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            let predicate = NSPredicate(format:"taskid = %d", self.taskId!)
            request.predicate = predicate
            self.note = try context.fetch(request)
            let not = self.note![0]
            txtVw.text = not.taskdetail
            txtTitle.text = not.taskname
        }
        catch{
            print("Error fetching the data")
        }
    }
    
    /*-------------------------------------------------------------------------------------------*/

    @objc func clickDoneButton(){
        if self.taskId != nil{
            self.updateTask()
        }
        else{
            self.saveNewTask()
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    private func saveNewTask(){
        
        let taskObj = Task(context: context)
        let uniqueNumber = Int(arc4random_uniform(30000))
        taskObj.taskid = Int64(uniqueNumber)
        taskObj.taskname = txtTitle.text
        taskObj.taskdetail = txtVw.text
        taskObj.createdat = NSDate() as Date
        taskObj.updatedat = NSDate() as Date
        taskObj.colorindex = Int64(selectedColorIndex)
        do{
            try self.context.save()
        }
        catch{
            print("Error in storing the task")
        }
    }
    
    private func updateTask(){
        do{
        let request = Task.fetchRequest() as NSFetchRequest<Task>
            let predicate = NSPredicate(format:"taskid = %d", self.taskId!)
        request.predicate = predicate
        self.note = try context.fetch(request)
        let not = self.note![0]
        not.taskdetail = txtVw.text
        not.taskname = txtTitle.text
        not.updatedat = NSDate() as Date

        }
        catch{
            print("Error found in upading the task")
        }
    }
   
}

/*-------------------------------------------------------------------------------------------*/

extension TaskDetailViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText newText: String) -> Bool {
 
        if (textView.text.count > 0){
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
            return true
    }
}
/*-------------------------------------------------------------------------------------------*/
extension TaskDetailViewController: UITextFieldDelegate{
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if (textField.text!.count > 0){
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        return true
    }
}
