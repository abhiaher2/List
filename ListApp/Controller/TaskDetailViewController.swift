//
//  TaskDetailViewController.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/17/21.
//

import UIKit
import CoreData


class TaskDetailViewController: UIViewController {
   
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tskTextField = TaskTextField()
    
    var tskTextView = TaskTextView()
    
    var button : UIButton?
    var taskId : Int?
    var note: [Task]?
    var vc : ChooseColorViewController?
    
    var keyboardHeight: CGFloat = 100.0 {
        didSet{
            self.configureTextVw()
        }
    }

    var selectedColorIndex = 3
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureTextField()
        
        self.registerForKeyboardNotification()
        
        self.addTabBarAboveKeyboard()

        self.setUpNavigationBar()
        
        self.updateColor(index: selectedColorIndex)

        guard self.taskId != nil else {return}
        self.getTask()
    }
    
    
    final func configureTextField(){
        self.view.addSubview(self.tskTextField)
        self.tskTextField.delegate = self
        
        NSLayoutConstraint.activate([
            self.tskTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            self.tskTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            self.tskTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            self.tskTextField.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    
    final func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    @objc func keyboardDidShow(notification:Notification){
        guard let info = notification.userInfo else { return }
            guard let frameInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
        let keyboardFrame = frameInfo.cgRectValue
            print("keyboardFrame: \(keyboardFrame)")
    
        // 20: textfield top anchor height
        let remainingHeight = self.topbarHeight +  self.tskTextField.frame.size.height + CGFloat(20)
      
        self.keyboardHeight = self.view.frame.size.height - (keyboardFrame.size.height + remainingHeight)
    }
    
    
    final func configureTextVw(){
        
        self.view.addSubview(tskTextView)
        
        NSLayoutConstraint.activate([
            tskTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),

            tskTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tskTextView.topAnchor.constraint(equalTo: self.tskTextField.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            tskTextView.heightAnchor.constraint(equalToConstant: self.keyboardHeight)
        ])
    }
        
   
    final func addTabBarAboveKeyboard(){
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        fixedSpace.width = 20
        
        let bar = UIToolbar()
        bar.barStyle = .default
        let photo = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(galleryPhoto))
        
        let camera = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(cameraPhoto))
        
        let font = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(fontClicked))
        
        let share = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareClicked))

        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append(photo)
        items.append(fixedSpace)
        items.append(camera)
        items.append(fixedSpace)
        items.append(font)
        items.append(fixedSpace)
        items.append(share)
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        bar.items = items
        
        bar.sizeToFit()
        tskTextView.inputAccessoryView = bar
    }
    
    
    @objc func shareClicked(){
        
    }
    
    
    @objc func fontClicked(){
        
    }
    
    
    @objc func galleryPhoto(){
        
    }
    
    
    @objc func cameraPhoto(){
        
    }
    
    
    private func setUpNavigationBar(){
        let doneButton   = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickDoneButton))
        button = UIButton(type: .custom)
        button!.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button?.layer.cornerRadius = 15
        button!.addTarget(self, action: #selector(clickChooseColor), for: .touchUpInside)
        
        let item = UIBarButtonItem(customView: button!)
        navigationItem.rightBarButtonItems = [ doneButton,item]
    }
    
    
    private func updateColor(index: Int?){
        button?.backgroundColor = CustomColor.getColor(colorIndex: index!)
        self.view.backgroundColor = CustomColor.getColor(colorIndex: index!)
        self.selectedColorIndex = index!
        self.removeChildVC()
    }

    private func removeChildVC(){
        self.vc?.view.removeFromSuperview()
        self.vc?.removeFromParent()
        self.vc = nil
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeChildVC()
    }
    
    
    @objc private func clickChooseColor(){
        
        
        vc =  self.storyboard?.instantiateViewController(withIdentifier: "ChooseColorVC") as? ChooseColorViewController
        vc!.setColor(completion: updateColor)
        vc!.view.frame.origin.y = self.topbarHeight
        vc!.view.frame.size.height = 250
        vc!.view.backgroundColor = .black
        self.view.addSubview(vc!.view)
        self.addChild(vc!)
        vc!.didMove(toParent: self)
    }
   
    
    deinit {
        print("in deinit from task detail ")
    }
    
    
    /*-------------------------------------------------------------------------------------------*/
    private func getTask(){
        
        do{
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            let predicate = NSPredicate(format:"taskid = %d", self.taskId!)
            request.predicate = predicate
            self.note = try AppManager.context.fetch(request)
            let not = self.note![0]
            tskTextView.text = not.taskdetail
            tskTextField.text = not.taskname
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
        
        guard  (!tskTextField.text!.isEmpty) || !tskTextView.text.isEmpty else {
            print("Empty data. Not saved.")
            return}

        
        let taskObj = Task(context: context)
        let uniqueNumber = Int(arc4random_uniform(30000))
        taskObj.taskid = Int64(uniqueNumber)
        taskObj.taskname = tskTextField.text
        taskObj.taskdetail = tskTextView.text
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
        not.taskdetail = tskTextView.text
        not.taskname = tskTextField.text
        not.updatedat = NSDate() as Date
        not.colorindex = Int64(selectedColorIndex)
        }
        catch{
            print("Error found in upading the task")
        }
    }
}



extension TaskDetailViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tskTextView.becomeFirstResponder()
        return true
    }
}
