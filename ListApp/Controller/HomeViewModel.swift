//
//  HomeViewModel.swift
//  ListApp
//
//  Created by Abhijeet Aher on 2/21/21.
//

import Foundation
import UIKit

class HomeViewModel{
    var updateDisplayUI :(() -> ())?
    var dataManager : DataManager
    var isShow  = false {
        didSet{
            self.updateDisplayUI?()
        }
    }
    private var dictNotes : [noteType : [Task]] = [noteType : [Task]]()
    
    
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func fetchData(){
        self.dataManager.fetchData { (result) in
            switch result{
            case .success(let dictNotes):
                print(dictNotes)
                self.dictNotes = dictNotes
                if(self.dictNotes.count > 0){
                    self.isShow = true
                }
                else{
                    self.isShow = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getDataSource(index: Int, isResultControllerActive: Bool) -> [Task]?
    {
        var tempNotes : [Task]?
        
//        if (isResultControllerActive) {
//            return self.filteredNotes
//        }
        
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
    
    func getTableViewTitle(for section: Int , isResultControllerActive: Bool ) -> String {
            
            var sectionName: String = ""
            
            if (isResultControllerActive) {
                return sectionName
            }
            let tempPNotes = self.dictNotes[noteType.PinnedNote]?.count ?? 0
            let tempUnNotes = self.dictNotes[noteType.Note]?.count ?? 0
            
            if (tempUnNotes > 0 && tempPNotes > 0){
                switch section {
                case 1:
                    sectionName = "Recent"
                default:
                    sectionName = "Pinned"
                }
                return sectionName
            }
            
            if (tempPNotes > 0){
                sectionName = "Pinned"
                return sectionName
            }
            
            if (tempUnNotes > 0){
                sectionName = "Recent"
                return sectionName
            }
            return sectionName
        }
        
        func getNumberOfSection(isResultControllerActive: Bool ) -> Int {
            if (isResultControllerActive) {
                return 1
            }
            
            let tempPNotes = self.dictNotes[noteType.PinnedNote]?.count ?? 0
            let tempUnNotes = self.dictNotes[noteType.Note]?.count ?? 0
            
            if(tempPNotes > 0 && tempUnNotes > 0) { return 2 }
            return 1
        }
        
        
        func leadingSwipeActionConfig(indexPath: IndexPath, isResultControllerActive: Bool) -> UISwipeActionsConfiguration?
        {
        
        let task = self.getDataSource(index: indexPath.section, isResultControllerActive: isResultControllerActive)![indexPath.row]
        
        let closeAction = UIContextualAction(style: .normal, title:  "Pin", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            if (task.ispinned){
                print("OK, marked as unpinned")
                task.ispinned = false
              //  self.pinnedCount -= 1
            }
            else{
                print("OK, marked as pinned")
                task.ispinned = true
                //  self.moveTableViewCell(indexPath: indexPath)
               // self.pinnedCount += 1
            }
            do{
                try AppManager.context.save()
            }
            catch{
                print("Error in storing the task")
            }
            success(true)
            self.fetchData()
            //self.animateTable()
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
    
    
    func deleteData(indexPath: IndexPath, isResultControllerActive: Bool){
        let notesObj = self.getDataSource(index: indexPath.section, isResultControllerActive: isResultControllerActive)![indexPath.row]
        AppManager.context.delete(notesObj)
        do{
            try AppManager.context.save()
        }
        catch{
            print("Error in storing the task")
        }
        self.fetchData()
    }
}

