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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
