import UIKit
import Firebase
import FirebaseFirestore
import ObjectMapper
import ViewAnimator

class SavedBeetleController: UIViewController, BeetleCellDelegate {

    @IBOutlet weak var savedBeetlesTableView: UITableView!
   
    var arrayOfBeetles: [Beetle] = []
       var sortedArrayOfBeetles: [Beetle] = []
       let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
       
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
       
       override func viewDidLoad() {
           super.viewDidLoad()
           savedBeetlesTableView.dataSource = self
           savedBeetlesTableView.delegate = self
           titleBomk(with: navigationItem)
           animator.addAnimations {
               self.savedBeetlesTableView.alpha = 1.0
           }
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           fetchDataFromFirestore()
       }
       
       func didUpdateBeetleData() {
           fetchDataFromFirestore()
       }
       
       func fetchDataFromFirestore() {
           arrayOfBeetles.removeAll()
           sortedArrayOfBeetles.removeAll()
           
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
                       self.reloadTableViewWithAnimation()
                    
                   } else {
                       print("No documents found.")
                   }
               }
           }
       }
    func reloadTableViewWithAnimation() {
           let animation = AnimationType.from(direction: .left, offset: 30.0)
           UIView.animate(views: savedBeetlesTableView.visibleCells, animations: [animation])
            self.savedBeetlesTableView.reloadData()
            self.animator.startAnimation()
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
    func updateFirestoreDocument(for beetle: Beetle) {
            let db = Firestore.firestore()
            guard let documentID = beetle.documentID else {
                print("Document ID is missing.")
                return
            }
            
            let documentReference = db.collection("beetles").document(documentID)

            documentReference.updateData(["isSaved": false]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document successfully updated!")
                }
            }
        }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDeleteSavedBeetle = UIContextualAction(style: .destructive, title: "Видалити") { _, _, completion in
                   completion(true)
                   
                   let beetleToRemove = self.sortedArrayOfBeetles[indexPath.row]
                   beetleToRemove.isSaved = false
                   
                   DispatchQueue.main.async {
                       self.sortedArrayOfBeetles.remove(at: indexPath.row)
                       self.savedBeetlesTableView.reloadData()
                       
                       // Оновлюємо дані в Firestore (якщо потрібно)
                       self.updateFirestoreDocument(for: beetleToRemove)
                   }
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
