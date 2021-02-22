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

final class HomeViewController: UIViewController {
    var homeVM : HomeViewModel = {
        return HomeViewModel()
    }()
    
    var pinnedCount = 0
    
    @IBOutlet weak var vwAddTask: UIView!
    var resultSearchController = UISearchController()
    
    @IBOutlet weak var tblTask: UITableView!
    
    var filteredNotes = [Task]()
    var dictNotes = [noteType: [Task]]()
    
    @IBOutlet weak var lblAddTask: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))

        let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewTask))
        add.tintColor = .black
        navigationItem.rightBarButtonItem = add
        
        self.tblTask.tableFooterView = UIView()
        self.tblTask.isHidden = true
        self.getSearchBar()
        
        lblAddTask.attributedText = AppManager.makeAttributedString(with: AppManager.AddNotes, andBoldString: "+")
        
        initVM()
        
    }
    
    func initVM(){
        self.homeVM.updateDisplayUI = { [weak self] in
            let isShow = self?.homeVM.isShow ?? false
            
            if (isShow){
                self?.showTableViewAndSearchBar()
                self?.animateTable()
            }
            else{
                self?.hideTableViewAndSearchBar()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //self.fetchData()
        self.homeVM.fetchData()
       // self.animateTable()
        
        if (dictNotes.values.count > 0){
            self.homeVM.isShow = true
        }
    }

    
    private func animateTable(){
        self.tblTask.reloadData()
        let cells = self.tblTask.visibleCells
        
        let tableViewHeight = self.tblTask.bounds.size.width
        
        for cell in cells{
            cell.transform = CGAffineTransform(translationX: tableViewHeight, y: 0)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter)*0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil )
            delayCounter += 1
        }
        
    }
    
    
    private func showTableViewAndSearchBar(){
        self.tblTask.isHidden = false
        resultSearchController.searchBar.isHidden = false
        vwAddTask.isHidden = true
       
    }
    
    
    private func hideTableViewAndSearchBar(){
        self.tblTask.isHidden = true
        resultSearchController.searchBar.isHidden = true
        vwAddTask.isHidden = false
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
            controller.searchBar.isHidden = true
            controller.searchBar.backgroundColor = UIColor.init(named: "BackgroundColor")!
            controller.searchBar.tintColor = UIColor.init(named: "BackgroundColor")!
            tblTask.tableHeaderView = controller.searchBar
            tblTask.tableHeaderView?.backgroundColor = .clear
            return controller
        })()
    }
    
    
    //TODO: Check the fetch data logic as we should not fetch always. Also in the below code try to check of we can add the guard statement before assigning to the tempnotes.
    
    final func fetchData(){
        do{
            self.dictNotes.removeAll()
            
            let tempNotes = try AppManager.context.fetch(Task.fetchRequest()) as! [Task]
            if (tempNotes.count > 0){
                
                let tempUnPinned = tempNotes.filter{!$0.ispinned}.sorted(by: {$0.updatedat!.compare($1.updatedat!) == .orderedDescending})
                
                if (tempUnPinned.count > 0){
                    self.dictNotes[noteType.Note] = tempUnPinned
                }
                
                let tempPinned = tempNotes.filter{$0.ispinned}.sorted(by: {$0.updatedat!.compare($1.updatedat!) == .orderedDescending})
                
                if (tempPinned.count > 0){
                    self.dictNotes[noteType.PinnedNote] = tempPinned
                }
            }
            else{
                //self.hideTableViewAndSearchBar()
                self.homeVM.isShow = false
            }
        }
        catch{
            print("Error fetching the data")
        }
    }
    
    
    func getDataSource(index: Int) -> [Task]?
    {
        var tempNotes : [Task]?
        
        if (resultSearchController.isActive) {
            
            return self.filteredNotes
        }
        
        let tempPNotes = self.dictNotes[noteType.PinnedNote]?.count ?? 0
        let tempUnPNotes = self.dictNotes[noteType.Note]?.count ?? 0
        if(tempPNotes > 0 && tempUnPNotes > 0) {
            switch index {
            case 1:
                tempNotes = self.dictNotes[noteType.Note]
            default:
                tempNotes = self.dictNotes[noteType.PinnedNote]
            }
            return tempNotes
            }
        if(tempPNotes > 0){
            tempNotes = self.dictNotes[noteType.PinnedNote]
            return tempNotes
        }
        tempNotes = self.dictNotes[noteType.Note]
        return tempNotes
    }
}


extension HomeViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskDetailVC = self.storyboard?.instantiateViewController(identifier: "AddTaskDetail") as! TaskDetailViewController
        let task = self.homeVM.getDataSource(index: indexPath.section, isResultControllerActive: resultSearchController.isActive)![indexPath.row]
        taskDetailVC.taskId = Int(task.taskid)
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                
        return self.homeVM.leadingSwipeActionConfig(indexPath: indexPath, isResultControllerActive: resultSearchController.isActive )
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            self.homeVM.deleteData(indexPath: indexPath, isResultControllerActive: resultSearchController.isActive)
        }
    }
}


extension HomeViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.homeVM.getNumberOfSection(isResultControllerActive: resultSearchController.isActive)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.homeVM.getTableViewTitle(for: section, isResultControllerActive: resultSearchController.isActive)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let task =  self.homeVM.getDataSource(index: section, isResultControllerActive: resultSearchController.isActive) else {
            return 0
        }
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = self.homeVM.getDataSource(index: indexPath.section, isResultControllerActive: resultSearchController.isActive)![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCustomCell.reuseId, for: indexPath) as! TaskCustomCell
        cell.set(taskObj: task)
        return cell
        
    }
}



// Mark: Search result
extension HomeViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredNotes.removeAll(keepingCapacity: true)
        var tmpFilteredNotes = [Task]()
        
        for value in self.dictNotes.values{
            tmpFilteredNotes = value.filter{($0.taskname?.lowercased().contains(searchController.searchBar.text!.lowercased()))! ||
                
                ($0.taskdetail?.lowercased().contains(searchController.searchBar.text!.lowercased()))!
            }
            
            
            self.filteredNotes.append(contentsOf: tmpFilteredNotes)
        }
        tblTask.reloadData()
    }
}
