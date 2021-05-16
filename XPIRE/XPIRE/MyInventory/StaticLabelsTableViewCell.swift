//
//  StaticLabelsTableViewCell.swift
//  XPIRE
//
//  Created by Mando Quintana on 3/24/21.
//

import UIKit

class StaticLabelsTableViewCell: UITableViewCell {

    @IBOutlet var staticTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        staticTextLabel.adjustsFontForContentSizeCategory = true
        // Configure the view for the selected state
    }
    
}
