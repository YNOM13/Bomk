import UIKit

class BeetleTableVIewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    @IBOutlet weak var tableNameBeetle: UILabel!
    @IBOutlet weak var tableImageBeetle: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with beetle: Beetle?){
        tableNameBeetle.text = beetle?.name
        fetchingImage(imageView: tableImageBeetle, beetleImage: beetle?.image)
    }

}
