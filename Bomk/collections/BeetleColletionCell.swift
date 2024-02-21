import UIKit
import Nuke
import Kingfisher
import Firebase
import FirebaseFirestore


class BeetleColletionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBeetleView: UIImageView!
    @IBOutlet weak var beetleName: UILabel!
    
    var beetle:Beetle?
    
    override func awakeFromNib() {
          super.awakeFromNib()
          layer.cornerRadius = 20
          layer.masksToBounds = true
      }
    
    @IBOutlet weak var savedButton: UIButton!
    @IBAction func savedButtonTapped(_ sender: Any) {
        guard let beetle = self.beetle
        else {
            return
        }
        
        beetle.isSaved = !(beetle.isSaved ?? false)
        updateFirestoreDocument(for: beetle)
        
    }
    func configure(with beetle: Beetle?) {
        self.beetle = beetle
        beetleName.text = beetle?.name ?? "none"
        fetchingImage(imageView: imageBeetleView, beetleImage: beetle?.image)
        
        let saveButtonTitle = beetle?.isSaved == true ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        savedButton.setImage(saveButtonTitle, for: .normal)
        
    }
    func updateFirestoreDocument(for beetle: Beetle) {
        let db = Firestore.firestore()
        let documentReference = db.collection("beetles").document(beetle.documentID ?? "")

        documentReference.updateData(["isSaved": beetle.isSaved ?? false]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
}
