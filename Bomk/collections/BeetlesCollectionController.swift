import UIKit
import FirebaseFirestore
import ObjectMapper

class BeetlesCollectionController: UICollectionViewController, UISearchResultsUpdating {

    var arrayOfBeetles: Array<Beetle> = []
    var filteredBeetles: Array<Beetle> = []
    var searchController: UISearchController!
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredBeetles = arrayOfBeetles.filter { beetle in
                return beetle.name?.range(of: searchText, options: .caseInsensitive) != nil
            }
        } else {
            filteredBeetles = arrayOfBeetles
        }
        
        collectionView.reloadData()
    }
    
    func searchBar () {
        //read about it more again
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Beetles"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        collectionView.delegate = self
        
        searchController.tabBarController?.tabBar.backgroundColor = .black
        searchController.tabBarItem.badgeColor = .black
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.barTintColor = UIColor.black
        
        fetchDataFromFirestore()
        
        titleBomk(with: navigationItem)
    } 
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBar()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10,left: 10,bottom: 15,right: 10)
        
         
    }
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    func fetchDataFromFirestore() {
        let db = Firestore.firestore()

            db.collection("beetles").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                } else {
                    if let documents = snapshot?.documents {
                        for document in documents {
                            let data = document.data()
                            print(document.data())

                            if let beetle = Mapper<Beetle>().map(JSON: data) {
                                beetle.isSaved = data["isSaved"] as? Bool
                                beetle.documentID = document.documentID // Assuming you have a property for the document ID in your Beetle model
                                self.arrayOfBeetles.append(beetle)
                            }
                        }
                        self.myCollectionView.reloadData()
                    } else {
                        print("No documents found.")
                    }
                }
            }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchController.isActive ? filteredBeetles.count : arrayOfBeetles.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let beetleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeetleColletionCell", for: indexPath) as? BeetleColletionCell else {
            return UICollectionViewCell()
        }

        let beetle = searchController.isActive ? filteredBeetles[indexPath.row] : arrayOfBeetles[indexPath.row]
        beetleCell.configure(with: beetle)
        
        return beetleCell
    }


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBeetle: Beetle
        
        if searchController.isActive {
            selectedBeetle = filteredBeetles[indexPath.row]
        } else {
            selectedBeetle = arrayOfBeetles[indexPath.row]
        }
        
        if let vc = storyboard?.instantiateViewController(identifier: "NavigatedBeetlesInfo") as? NavigatedBeetlesInfo {
            vc.name = selectedBeetle.name ?? "None"
            vc.image = selectedBeetle.image ?? ""
            vc.fact = selectedBeetle.fact ?? "None"
            vc.story = selectedBeetle.story ?? "None"
            vc.spread = selectedBeetle.spread ?? "No info"
            navigationController?.pushViewController(vc, animated: true)
        }
    }

   
}
