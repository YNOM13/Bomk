import Foundation
import UIKit

func titleBomk(with navigationItem: UINavigationItem) {
    if let logo = UIImage(named: "beetle-logo-black.png") {
        let newSize = CGSize(width: 75, height: 25)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        logo.draw(in: CGRect(origin: .zero, size: newSize))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageView = UIImageView(image: resizedImage)
        imageView.sizeToFit()
        
        navigationItem.titleView = imageView
    }
}
