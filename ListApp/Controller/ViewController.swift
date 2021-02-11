//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/17/21.
//

import UIKit

enum noteType{
    case Note
    case PinnedNote
}

final class ViewController: UIViewController {
    
    
    var pinnedCount = 0
    
    var resultSearchController = UISearchController()

    @IBOutlet weak var tblTask: UITableView!
    
    var filteredNotes = [Task]()
    var dictNotes = [noteType: [Task]]()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        self.tblTask.tableFooterView = UIView()
        self.getSearchBar()
    }
    
    
    @objc func addNewTask(){
        
        let taskDetailVC = self.storyboard?.instantiateViewController(identifier: "AddTaskDetail") as! TaskDetailViewController
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
    
    
    func getSearchBar(){
      resultSearchController = ({
               let controller = UISearchController(searchResultsController: nil)
               controller.searchResultsUpdater = self
               controller.dimsBackgroundDuringPresentation = false
               controller.searchBar.sizeToFit()
        controller.searchBar.backgroundColor = UIColor.init(named: "BackgroundColor")!
        controller.searchBar.tintColor = UIColor.init(named: "BackgroundColor")!
               tblTask.tableHeaderView = controller.searchBar
        tblTask.tableHeaderView?.backgroundColor = .clear
               return controller
           })()
        
    }
    
 
    final func fetchData(){
        do{
            
            let tempNotes = try AppManager.context.fetch(Task.fetchRequest()) as [Task]
            
            self.dictNotes[noteType.Note] = tempNotes.filter{!$0.ispinned}.sorted(by: {$0.updatedat!.compare($1.updatedat!) == .orderedDescending})
            
            self.dictNotes[noteType.PinnedNote] = tempNotes.filter{$0.ispinned}.sorted(by: {$0.updatedat!.compare($1.updatedat!) == .orderedDescending})

            tblTask.reloadData()
        }
        catch{
            print("Error fetching the data")
        }
    }
    
    func getDataSource(index: Int) -> [Task]?
    {
        let tempNotes : [Task]?
        
        if (resultSearchController.isActive) {
            
            return self.filteredNotes
          }
        
        guard let pinnedNotesCount = self.dictNotes[noteType.PinnedNote]?.count else {
            
            tempNotes = self.dictNotes[noteType.Note] ?? nil
            return tempNotes

        }
            switch index {
            case 1:
                tempNotes = self.dictNotes[noteType.Note]
            default:
                tempNotes = self.dictNotes[noteType.PinnedNote]
            }
            return tempNotes
    }
    
    

    
    
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       

        let taskDetailVC = self.storyboard?.instantiateViewController(identifier: "AddTaskDetail") as! TaskDetailViewController
        let task = self.getDataSource(index: indexPath.section)![indexPath.row]
        taskDetailVC.taskId = Int(task.taskid)
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        
        let task = self.getDataSource(index: indexPath.section)![indexPath.row]
        
        let closeAction = UIContextualAction(style: .normal, title:  "Pin", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            if (task.ispinned){
                print("OK, marked as unpinned")
                task.ispinned = false
                self.pinnedCount -= 1
            }
            else{
                print("OK, marked as pinned")
                task.ispinned = true
              //  self.moveTableViewCell(indexPath: indexPath)
                self.pinnedCount += 1
            }
            do{
                try AppManager.context.save()
            }
            catch{
                print("Error in storing the task")
            }
            success(true)
            self.fetchData()
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
            
            let notesObj = self.getDataSource(index: indexPath.section)![indexPath.row]
            AppManager.context.delete(notesObj)
            do{
                try AppManager.context.save()
            }
            catch{
                print("Error in storing the task")
            }
            self.dictNotes.removeAll()
            fetchData()
            
        }
    }
}

// Mark: Search result
extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredNotes.removeAll(keepingCapacity: true)
        var tmpFilteredNotes = [Task]()

        for value in self.dictNotes.values{
            tmpFilteredNotes = value.filter{($0.taskname?.lowercased().contains(searchController.searchBar.text!.lowercased()))!}
            self.filteredNotes.append(contentsOf: tmpFilteredNotes)
        }
        tblTask.reloadData()
    }
}



extension ViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (resultSearchController.isActive) {
            return 1
        }
        
        guard let pinnedNotesCount = self.dictNotes[noteType.PinnedNote]?.count else {return 1}
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName: String
        
        if (resultSearchController.isActive) {
            sectionName = ""
            return sectionName

        }
        
        guard let pinnedNotesCount = self.dictNotes[noteType.PinnedNote]?.count else
        {
            sectionName = "Recent"
            return sectionName
        }
            switch section {
            case 1:
                sectionName = "Recent"
            default:
                sectionName = "Pinned"
            }
        return sectionName
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let task =  self.getDataSource(index: section) else {
            return 0
        }
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let task = self.getDataSource(index: indexPath.section)![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCustomCell.reuseId, for: indexPath) as! TaskCustomCell
        cell.set(taskObj: task)
        return cell
        
    }
}
