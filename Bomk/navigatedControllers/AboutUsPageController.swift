import UIKit
import Lottie


class AboutUsPageController: UIViewController {
    @IBOutlet weak var animationGirlLearning: LottieAnimationView!
    @IBOutlet weak var aboutUsTextInfo: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBomk(with: navigationItem)
        animationGirlLearning?.contentMode = .scaleAspectFit
        animationGirlLearning?.loopMode = .loop
        animationGirlLearning?.animationSpeed = 0.5
        animationGirlLearning?.play()
    }
}
