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
    @IBOutlet weak var rareBeetlesCollectionView: UICollectionView!
    
    var arrayOfBeetles: Array<Beetle> = []
    var saveOurBeetles:Array<SaveBeetles> = []
    var rareBeetles: Array<RareBeetles> = []
    
    var isCollectionHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBomk(with: navigationItem)
        fetchDataFromFirestore()
        fetchSavingPopulationOfBeetles()
        updateBeetleCountLabel()
        fetchRareBeetles()
    }
    
    @IBAction func hideCollectionAction(_ sender: Any) {
        isCollectionHidden = !isCollectionHidden
        
        if isCollectionHidden{
            saveBeetleCollectionView.isHidden = isCollectionHidden
            hideCollectionButton.setTitle("Відкрити 😃", for: .normal)

        }else{
            saveBeetleCollectionView.isHidden = isCollectionHidden
            hideCollectionButton.setTitle("Закрити 😢", for: .normal)
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
    func fetchRareBeetles() {
        let db = Firestore.firestore()
        db.collection("rareBeetles").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found.")
                return
            }
            
            var rareBeetles = [RareBeetles]()
            for document in documents {
                let data = document.data()
                if let saveBeetle = Mapper<RareBeetles>().map(JSON: data) {
                    saveBeetle.documentID = document.documentID
                    rareBeetles.append(saveBeetle)
                }
                self.rareBeetlesCollectionView.reloadData()
            }
            self.rareBeetles = rareBeetles
        }
    }
}

extension BomkController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == saveBeetleCollectionView {
            return saveOurBeetles.count
        } else if collectionView == rareBeetlesCollectionView {
            return rareBeetles.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == saveBeetleCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savePopulation", for: indexPath) as! SaveBeetlePopulationCell
            cell.setData(info: saveOurBeetles[indexPath.row])
            return cell
        } else if collectionView == rareBeetlesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rareBeetlesCell", for: indexPath) as! RareBeetlesCell
            cell.setData(info: rareBeetles[indexPath.row])
            return cell
        }
        fatalError("Unexpected collection view")
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

class RareBeetlesCell: UICollectionViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageBeetle: UIImageView!
    
    func setData(info: RareBeetles){
        nameLabel.text = info.name
        fetchingImage(imageView: imageBeetle, beetleImage: info.image)
    }
}
