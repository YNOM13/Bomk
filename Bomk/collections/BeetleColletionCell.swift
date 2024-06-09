import UIKit
import Kingfisher
import Firebase
import FirebaseFirestore

protocol BeetleCellDelegate: AnyObject {
    func didUpdateBeetleData()
}


class BeetleColletionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBeetleView: UIImageView!
    @IBOutlet weak var beetleName: UILabel!
    @IBOutlet weak var savedButton: UIButton!
  
    var beetle:Beetle?
    
    override func awakeFromNib() {
          super.awakeFromNib()
          layer.cornerRadius = 20
          layer.masksToBounds = true
      }
    
    @IBAction func savedButtonTapped(_ sender: Any) {
        guard let beetle = self.beetle else {
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
    
    weak var delegate: BeetleCellDelegate?

    func updateFirestoreDocument(for beetle: Beetle) {
        let db = Firestore.firestore()
        let documentReference = db.collection("beetles").document(beetle.documentID ?? "")

        documentReference.updateData(["isSaved": beetle.isSaved ?? false]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated!")
                
                self.delegate?.didUpdateBeetleData()
            }
        }
    }
}
