//
//  RepairTableViewCell.swift
//  Ims Repair
//
//  Created by Kevin Tierney on 12/18/20.
//

import UIKit

class RepairTableViewCell: UITableViewCell {
    
    @IBOutlet var company: UILabel!
    @IBOutlet var tool: UILabel!
    @IBOutlet var status:UIImageView!
    @IBOutlet var shadow: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
extension UIView {

    func addShadow(Color: UIColor) {
        layer.shadowColor = Color.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 0.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        clipsToBounds = false
    }
}
