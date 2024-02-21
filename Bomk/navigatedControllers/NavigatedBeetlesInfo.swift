import UIKit
import Kingfisher

class NavigatedBeetlesInfo: UIViewController {

    var name:String = ""
    var image:String = ""
    var fact: String = ""
    var story: String = ""
    var spread: String = ""
    
    
    @IBOutlet weak var factBeetle: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storyBeetle: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBeetlePage()
        titleBomk(with: navigationItem)
       
    }

    @IBAction func shareButton(_ sender: Any) {
        let avc = UIActivityViewController.init(activityItems: [name, fact, story ], applicationActivities: nil)
        present(avc, animated: true)
    }
    
    func updateBeetlePage() {
        nameLabel.text = name.isEmpty ? "Name is not available" : name
        factBeetle.text = fact.isEmpty ? "Fact is not available" : fact
        storyBeetle.text = story.isEmpty ? "Fact is not available" : story
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        fetchingImage(imageView: imageView, beetleImage: image)
        
        selfSizeTheTextView(with: factBeetle)
        selfSizeTheTextView(with: storyBeetle)
    }
    
    func selfSizeTheTextView(with arg:UITextView){
        arg.isScrollEnabled = false
        arg.textContainerInset = UIEdgeInsets.zero
        arg.textContainer.lineFragmentPadding = 10
        arg.sizeToFit()
//        arg.translatesAutoresizingMaskIntoConstraints = true
    }


}
