//
//  BomkController.swift
//  Bomk
//
//  Created by Yaroslav on 4/17/24.
//

import UIKit
import Firebase
import ObjectMapper

class BomkController: UIViewController{
    @IBOutlet weak var countOfBeetleLabel: UILabel!
    @IBOutlet weak var saveBeetleCollectionView: UICollectionView!
    @IBOutlet weak var hideCollectionButton: UIButton!
    
    var arrayOfBeetles: Array<Beetle> = []
    var saveOurBeetles:Array<SaveBeetles> = []
    
    var isCollectionHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBomk(with: navigationItem)
        fetchDataFromFirestore()
        fetchSavingPopulationOfBeetles()
        updateBeetleCountLabel()
    }
    
    @IBAction func hideCollectionAction(_ sender: Any) {
        isCollectionHidden = !isCollectionHidden
        
        if isCollectionHidden{
            saveBeetleCollectionView.isHidden = isCollectionHidden
            hideCollectionButton.setTitle("Відкрити", for: .normal)

        }else{
            saveBeetleCollectionView.isHidden = isCollectionHidden
            hideCollectionButton.setTitle("Закрити", for: .normal)
        }
    }
    
    func updateBeetleCountLabel() {
        countOfBeetleLabel.text = "\(arrayOfBeetles.count) комах в нашій базі даних."
    }
    
    func fetchDataFromFirestore() {
        let db = Firestore.firestore()
        db.collection("beetles").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found.")
                return
            }
            
            var newBeetles = [Beetle]()
            for document in documents {
                let data = document.data()
                print(data)
                if let beetle = Mapper<Beetle>().map(JSON: data) {
                    beetle.isSaved = data["isSaved"] as? Bool ?? false
                    beetle.documentID = document.documentID
                    newBeetles.append(beetle)
                }
            }
            self.arrayOfBeetles = newBeetles
            self.updateBeetleCountLabel()
        }
        
    }
    func fetchSavingPopulationOfBeetles() {
        let db = Firestore.firestore()
        db.collection("saveBeetlesPopulation").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found.")
                return
            }
            
            var savePopulation = [SaveBeetles]()
            for document in documents {
                let data = document.data()
                if let saveBeetle = Mapper<SaveBeetles>().map(JSON: data) {
                    saveBeetle.documentID = document.documentID
                    savePopulation.append(saveBeetle)
                }
                self.saveBeetleCollectionView.reloadData()
            }
            self.saveOurBeetles = savePopulation
        }
    }
}

extension BomkController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saveOurBeetles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savePopulation", for: indexPath) as! SaveBeetlePopulationCell
        
        cell.setData(info: saveOurBeetles[indexPath.row])
        
        return cell
    }
}

class SaveBeetlePopulationCell: UICollectionViewCell{
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    func setData(info: SaveBeetles){
        textLabel.text = info.text
        nameLabel.text = info.name
    }
}
