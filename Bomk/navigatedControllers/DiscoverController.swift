//
//  DiscoverController.swift
//  Bomk
//
//  Created by Yaroslav on 4/14/24.
//

import UIKit
import Kingfisher

class DiscoverController: UIViewController{
    @IBOutlet weak var imageDiscoverer: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discovererLabel: UILabel!
    
    var discovererName: String = ""
    var discovererPhoto: String = ""
    var discovererDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = discovererName
        discovererLabel.text = discovererDescription
      
        fetchingImage(imageView: imageDiscoverer, beetleImage: discovererPhoto)
    }
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
