//
//  ChooseColorViewController.swift
//  WeatherApp
//
//  Created by Abhijeet Aher on 1/22/21.
//

import UIKit

class ChooseColorViewController: UIViewController {

     var selectedColor: ((Int?) -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setColor(completion:((Int?) -> Void)?){
        self.selectedColor = completion
    }
    
    deinit {
        print("in deinit from choose color")
    }
    

}

enum CustomColor:Int, CaseIterable{
    case red = 0
    case green
    case blue
    case yellow
    case gray
    case black
    
    
    static func getColor(colorIndex:Int) -> UIColor {
        
        switch colorIndex {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.green
        case 2:
            return UIColor.blue
        case 3:
            return UIColor.yellow
        case 4:
            return UIColor.gray
        default:
            return UIColor.black
        }

}


}

extension ChooseColorViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CustomColor.allCases.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = CustomColor.getColor(colorIndex:indexPath.row)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func test(ind: Int){
        if let block = selectedColor {
               block(ind)
           }
    }
}

extension ChooseColorViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        self.dismiss(animated: true) { [self] in
            if let block = selectedColor {
                block(indexPath.row)
               }
            
        }
    }
}


extension ChooseColorViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
