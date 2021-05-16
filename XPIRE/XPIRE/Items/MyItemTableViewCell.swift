//
//  MyItemTableViewCell.swift
//  XPIRE
//
//  Created by Mando Quintana on 3/1/21.
//

import UIKit

class MyItemTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var purchasedDate: UILabel!
    @IBOutlet var expiringDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
