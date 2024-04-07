//
//  InfoScreen.swift
//  Bomk
//
//  Created by Yaroslav on 3/17/24.
//

import UIKit

class InfoScreen: UIViewController{
    var PageViewController: PageViewController? = nil

    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func buttonPressNext(_ sender: Any) {
        PageViewController?.next()
        animateProgressBar()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animateProgressBar()
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PageViewController{
            self.PageViewController = vc
            vc.parentController = self
        }
    }
    private func animateProgressBar() {
        let step = Float((100.0 / Float(PageViewController?.items.count ?? 0)) / 100.0)
            let currentPage = Float((PageViewController?.currentIndex ?? 0) + 1)
            let progress = Float(currentPage * step)
        
           UIView.animate(withDuration: 0.3) {
               self.progressBar.setProgress(progress, animated: true)
           }
       }
}
