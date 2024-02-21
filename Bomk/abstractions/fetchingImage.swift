import Foundation
import UIKit
import Kingfisher

func fetchingImage(imageView: UIImageView!, beetleImage: String?){
    if let image = beetleImage {
        let url = URL(string: image)
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "loading-beetle.png"), options: nil, completionHandler: { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print("Image loading error: \(error)")
            }
        })
    } else {
        imageView.image = UIImage(named: "loading-beetle.png")
    }
}
