//
//  InfoHowToSaveController.swift
//  Bomk
//
//  Created by Yaroslav on 4/16/24.
//

import Lottie
import UIKit

class InfoHowToSaveController: UIViewController {
    @IBOutlet weak var animationSwipeView: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBomk(with: navigationItem)
        animationSwipeView?.contentMode = .scaleAspectFit
        animationSwipeView?.loopMode = .loop
        animationSwipeView?.animationSpeed = 0.5
        animationSwipeView?.play()
    }
}
