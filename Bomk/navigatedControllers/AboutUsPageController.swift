import UIKit
import Lottie


class AboutUsPageController: UIViewController {


    @IBOutlet weak var animationGirlLearning: LottieAnimationView!
    
    @IBOutlet weak var aboutUsTextInfo: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBomk(with: navigationItem)
        selfSizeTheTextView(with: aboutUsTextInfo)
        animateUiView(with: animationGirlLearning)
    }
    
    func animateUiView(with arg:LottieAnimationView){
        arg.contentMode = .scaleAspectFit
        arg.loopMode = .loop
        arg.animationSpeed = 0.5
        arg.play()
    }
    func selfSizeTheTextView(with arg:UITextView){
        arg.text = ""
        arg.isScrollEnabled = false
        arg.textContainerInset = UIEdgeInsets.zero
        arg.textContainer.lineFragmentPadding = 10
        arg.sizeToFit()
//        arg.translatesAutoresizingMaskIntoConstraints = false

    }
   

}
