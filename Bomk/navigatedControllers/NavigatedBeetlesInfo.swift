import UIKit
import Kingfisher

class NavigatedBeetlesInfo: UIViewController {

    var name:String = ""
    var image:String = ""
    var fact: String = ""
    var story: String = ""
    var spread: String = ""
    var discovererName: String = ""
    var discovererPhoto: String = ""
    var discovererDescription: String = ""
    
    @IBOutlet weak var factBeetle: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storyBeetle: UILabel!
    @IBOutlet weak var spreadLabel: UILabel!
    @IBOutlet weak var discovererButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBeetlePage()
        titleBomk(with: navigationItem)
        
    }

    @IBAction func shareButton(_ sender: Any) {
        let avc = UIActivityViewController.init(activityItems: [name, fact, story ], applicationActivities: nil)
        present(avc, animated: true)
    }
    @IBAction func discovererAction(_ sender: Any) {
        if let myVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier:"discover") as? DiscoverController {
//            myVC.discoverer = discoverer
            myVC.discovererName = discovererName
            myVC.discovererPhoto = discovererPhoto
            myVC.discovererDescription = discovererDescription
            present (myVC, animated: true)
        }
    }
    
    func updateBeetlePage() {
        
        spreadLabel.text = spread.isEmpty ? "404" : spread
        nameLabel.text = name.isEmpty ? "Name is not available" : name
        discovererButton.setTitle("Відкривач \(discovererName.isEmpty ? "відсутній" : discovererName)", for: .normal)
        
        if discovererName.isEmpty {
            discovererButton.isEnabled = false
        }else{
            discovererButton.isEnabled = true
        }
        
        factBeetle.text = fact.isEmpty ? "Fact is not available" : fact
        storyBeetle.text = story.isEmpty ? "Story is not available" : story
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        fetchingImage(imageView: imageView, beetleImage: image)
        
    }
    
}
