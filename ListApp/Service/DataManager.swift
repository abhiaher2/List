//
//  DataManager.swift
//  ListApp
//
//  Created by Abhijeet Aher on 2/21/21.
//

import Foundation

enum error: String, Error {
    case errorGettingData
    
    var description: String{
        switch self{
        case .errorGettingData :
            return "Erorr getting the notes"
        }
    }
}

class DataManager {
    
    func fetchData(completionHandler: ( Result < [noteType: [Task]], error>) -> Void) {
        do{
            var dictNotes = [noteType:[Task]]()
            let tempNotes = try AppManager.context.fetch(Task.fetchRequest()) as! [Task]
            if (tempNotes.count > 0){
                
                let tempUnPinned = tempNotes.filter{!$0.ispinned}.sorted(by: {$0.updatedat!.compare($1.updatedat!) == .orderedDescending})
                
                if (tempUnPinned.count > 0){
                    dictNotes[noteType.Note] = tempUnPinned
                }
                
                let tempPinned = tempNotes.filter{$0.ispinned}.sorted(by: {$0.updatedat!.compare($1.updatedat!) == .orderedDescending})
                
                if (tempPinned.count > 0){
                   dictNotes[noteType.PinnedNote] = tempPinned
                }
            }
            else{
                //self.homeVM.isShow = false
            }
            
            completionHandler(.success(dictNotes))
        }
        catch{
            print("Error fetching the data")
            completionHandler(.failure(.errorGettingData))
        }
    }  
}
