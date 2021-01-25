//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/17/21.
//

import UIKit

final class ViewController: UIViewController {
    
    var pinnedCount = 0
    
    @IBOutlet weak var tblTask: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notes = [Task]()
    var pinnedNotes = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        
        self.fetchData()
        
    }
    
    
    
    @objc func addNewTask(){
        
        let taskDetailVC = self.storyboard?.instantiateViewController(identifier: "AddTaskDetail") as! TaskDetailViewController
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
        
        //      let addTaskVC = self.storyboard?.instantiateViewController(identifier: "AddTask") as! AddTaskViewController
        //
        //        addTaskVC.callPrev1(completionHandler: fetchData)
        //        self.present(addTaskVC, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchData()
    }
    
    final func fetchData(){
        do{
            
            self.notes = try context.fetch(Task.fetchRequest())
            self.notes = self.notes.sorted(by: {$0.updatedat!.compare($1.updatedat!) == .orderedDescending})
            
            tblTask.reloadData()
        }
        catch{
            print("Error fetching the data")
        }
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let taskDetailVC = self.storyboard?.instantiateViewController(identifier: "AddTaskDetail") as! TaskDetailViewController
        let task = notes[indexPath.row]
        taskDetailVC.taskId = Int(task.taskid)
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = self.notes[indexPath.row]
        
        let closeAction = UIContextualAction(style: .normal, title:  "Pin", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            if (task.ispinned){
                print("OK, marked as unpinned")
                task.ispinned = false
                self.pinnedCount -= 1
                self.notes.append(task)
                self.pinnedNotes.remove(at: indexPath.row)
                //self.moveTableViewCell(indexPath: indexPath)
                
            }
            else{
                print("OK, marked as pinned")
                task.ispinned = true
                self.moveTableViewCell(indexPath: indexPath)
                self.pinnedCount += 1
                self.notes.remove(at: indexPath.row)
                self.pinnedNotes.append(task)
            }
            success(true)
        })
        
        if (task.ispinned){
            closeAction.image = UIImage(systemName: "pin.slash")
            
        }
        else{
            closeAction.image = UIImage(systemName: "pin")
            
        }
        closeAction.backgroundColor = UIColor.systemGreen
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    
    func moveTableViewCell(indexPath: IndexPath){
        let firstVisibleIndexPath = (tblTask.indexPathsForVisibleRows?.first)!
        self.tblTask.moveRow(at: indexPath, to: firstVisibleIndexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            
            let notesObj = notes[indexPath.row]
            
            context.delete(notesObj)
            
            do{
                try self.context.save()
            }
            catch{
                print("Error in storing the task")
            }
            self.notes.removeAll()
            fetchData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension ViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if (pinnedCount > 0) { return 2 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName: String
        if (pinnedCount > 0)
        {
            switch section {
            case 1:
                sectionName = "Recent"
            default:
                sectionName = "Pinned"
            }
        }
        else{
            sectionName = "Recent"
        }
        return sectionName
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowsCount: Int
        if (pinnedCount > 0)
        {
            switch section {
            case 1:
                rowsCount = self.notes.count
            default:
                rowsCount = self.pinnedNotes.count
            }
        }
        else{
            rowsCount =  self.notes.count
        }
        return rowsCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempNotes : [Task]
        if (pinnedCount > 0)
        {
            switch indexPath.section {
            case 1:
                tempNotes = self.notes
            default:
                tempNotes = self.pinnedNotes

            }
        }
            else{
                tempNotes = self.notes

            }
        
        let task = tempNotes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskCustomCell
        cell.tasktext.text = task.taskname
        cell.taskDetail.text = task.taskdetail
        cell.createdAt.text = "Created at:\(self.getDateInString(date: task.createdat!))"
        cell.UpdatedAt.text = "Updated at: \(self.getDateInString(date:task.updatedat!))"
        cell.backgroundColor = CustomColor.getColor(colorIndex: Int(task.colorindex))
        return cell
        
    }
    
    private func getDateInString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, HH:mm"
        return formatter.string(from: date)
        
        
    }
    
    
}
