import UIKit
import Firebase
import FirebaseFirestore
import ObjectMapper

class SavedBeetleController: UIViewController {

    @IBOutlet weak var savedBeetlesTableView: UITableView!
    var arrayOfBeetles: [Beetle] = []
    var sortedArrayOfBeetles: [Beetle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedBeetlesTableView.dataSource = self
        savedBeetlesTableView.delegate = self
        fetchDataFromFirestore()
        titleBomk(with: navigationItem)
        
    }
    
    func isElementSaved() {
        sortedArrayOfBeetles.removeAll()
        
        for beetle in arrayOfBeetles {
            if beetle.isSaved ?? false {
                sortedArrayOfBeetles.append(beetle)
            } else {
                print("not working!!!")
            }
        }
    }
    
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
                            beetle.documentID = document.documentID
                            self.arrayOfBeetles.append(beetle)
                        }
                        self.isElementSaved()
                    }
                    self.savedBeetlesTableView.reloadData()
                } else {
                    print("No documents found.")
                }
            }
        }
    }

}


extension SavedBeetleController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArrayOfBeetles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeetleTableVIewCell", for: indexPath) as! BeetleTableVIewCell
        let arrowImage = UIImage(systemName: "chevron.right")?.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal)
            let arrowImageView = UIImageView(image: arrowImage)
            
            arrowImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            arrowImageView.isOpaque = false
            
            cell.accessoryView = arrowImageView
        cell.configure(with: sortedArrayOfBeetles[indexPath.row])
        return cell
    }
    
    
}
extension SavedBeetleController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDeleteSavedBeetle = UIContextualAction(style: .destructive, title: "Видалити") { _, _, completion in
            completion(true)

            if let documentID = self.sortedArrayOfBeetles[indexPath.row].documentID {
                //документ айді це унікальний ідентифікатор, який надається кожному документу у колекції.
                //короче це використовується для айді елемента аби керувати сетйтом та оновлювати його, також можна отримувати дані через нього
                
                let db = Firestore.firestore()
                db.collection("beetles").document(documentID).updateData(["isSaved": false]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    }
                }
            }

            self.sortedArrayOfBeetles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }

        actionDeleteSavedBeetle.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [actionDeleteSavedBeetle])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "NavigatedBeetleViewControllerFromTableVIew") as? NavigatedBeetleViewControllerFromTableVIew {
//            vc.name = arr.name ?? "No name"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
