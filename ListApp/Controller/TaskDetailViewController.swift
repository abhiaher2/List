//
//  TaskDetailViewController.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/17/21.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {
   
    @IBOutlet weak var heightConstraintsTxtVw: NSLayoutConstraint!
    // private var saveData : (() -> Void)? = nil

    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var txtVw: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    
    let tskTextView = TaskTextView()
    
    var  button : UIButton?
    var taskId : Int?
    var note: [Task]?
    var selectedColorIndex = 3
    
//    var textView : UITextView = {
//        let txtVw = UITextView()
//        txtVw.frame = CGRect()
//        return txtVw
//    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        txtTitle.becomeFirstResponder()
       
//        self.configureTextVw()
        
//        self.addTabBarAboveKayboard()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)

        self.setUpNavigationBar()

        guard self.taskId != nil else {return}
        self.getTask()
    }
    
    final func configureTextVw(){
        
        self.view.addSubview(tskTextView)
        
        NSLayoutConstraint.activate([
            tskTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),

            tskTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tskTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            tskTextView.heightAnchor.constraint(equalToConstant: 100)
  
        ])
    }
    
    @objc func keyboardDidShow(notification:Notification){
        guard let info = notification.userInfo else { return }
            guard let frameInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        /*
        let kbSize = frameInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        txtVw.contentInset = contentInsets
        txtVw.scrollIndicatorInsets = contentInsets
    }
        */
        let keyboardFrame = frameInfo.cgRectValue
            print("keyboardFrame: \(keyboardFrame)")
        

//        UIView.transition(with: txtVw, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.heightConstraintsTxtVw.constant =  self.view.frame.size.height -  (keyboardFrame.size.height + (self.navigationController?.navigationBar.frame.size.height)! + 40)
//        })
        
       
        self.view.layoutIfNeeded()
    }
        
           
 
    final func addTabBarAboveKayboard(){
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        fixedSpace.width = 20
        
        let bar = UIToolbar()
        bar.barStyle = .default
        let photo = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(gallaryPhoto))
        
        let camera = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(cameraPhoto))

        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append(photo)
        items.append(fixedSpace)
        items.append(camera)
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        bar.items = items
        
        bar.sizeToFit()
        txtVw.inputAccessoryView = bar

    }
    
    @objc func gallaryPhoto(){
        
    }
    
    @objc func cameraPhoto(){
        
    }
    
    private func setUpNavigationBar(){
        let doneButton   = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickDoneButton))
        button = UIButton(type: .custom)
        button!.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button!.addTarget(self, action: #selector(clickChooseColor), for: .touchUpInside)
        
        let item = UIBarButtonItem(customView: button!)
        navigationItem.rightBarButtonItems = [ doneButton,item]
        
        self.updateColor(index: selectedColorIndex)
    }
    
    @objc private func clickChooseColor(){
       let vc =  self.storyboard?.instantiateViewController(withIdentifier: "ChooseColorVC") as! ChooseColorViewController
        
        vc.setColor(completion: updateColor)
//        vc.selectedColor = { (index) in
//        self.button?.backgroundColor = CustomColor.getColor(colorIndex: index!)
//        self.view.backgroundColor = CustomColor.getColor(colorIndex: index!)
//            self.selectedColorIndex = index!
//        }
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    private func updateColor(index: Int?){
        button?.backgroundColor = CustomColor.getColor(colorIndex: index!)
        self.view.backgroundColor = CustomColor.getColor(colorIndex: index!)
        self.selectedColorIndex = index!
    }
    
    /*-------------------------------------------------------------------------------------------*/
    private func getTask(){
        
        do{
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            let predicate = NSPredicate(format:"taskid = %d", self.taskId!)
            request.predicate = predicate
            self.note = try AppManager.context.fetch(request)
            let not = self.note![0]
            txtVw.text = not.taskdetail
            txtTitle.text = not.taskname
            selectedColorIndex = Int(not.colorindex)
            self.updateColor(index: selectedColorIndex)
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
        
        guard  (!txtTitle.text!.isEmpty) || !txtVw.text.isEmpty else {
            print("Empty data. Not saved.")
            return}

        
        let taskObj = Task(context: context)
        let uniqueNumber = Int(arc4random_uniform(30000))
        taskObj.taskid = Int64(uniqueNumber)
        taskObj.taskname = txtTitle.text
        taskObj.taskdetail = txtVw.text
        taskObj.createdat = NSDate() as Date
        taskObj.updatedat = NSDate() as Date
        taskObj.colorindex = Int64(selectedColorIndex)
        taskObj.ispinned = false
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
        not.colorindex = Int64(selectedColorIndex)
        }
        catch{
            print("Error found in upading the task")
        }
    }
   
}

