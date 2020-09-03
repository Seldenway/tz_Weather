import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayTemperature: UILabel!
    @IBOutlet weak var nightTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
