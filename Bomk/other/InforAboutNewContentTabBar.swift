import UIKit

class InforAboutNewContentTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabItems = tabBar.items {
            let tabItem = tabItems[0]
            tabItem.badgeValue = "1"
        }
    }
    

   

}
