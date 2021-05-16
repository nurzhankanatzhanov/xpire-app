//
//  MyInventoryDetailsTableViewCell.swift
//  XPIRE
//
//  Created by Mando Quintana on 3/1/21.
//

import UIKit

class MyInventoryDetailsTableViewCell: UITableViewCell {

    @IBOutlet var tipLabel: UILabel!
    
    override func awakeFromNib() {
        tipLabel.adjustsFontForContentSizeCategory = true
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
