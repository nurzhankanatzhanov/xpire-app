//
//  SearchProductTableViewCell.swift
//  XPIRE
//
//  Created by Mando Quintana on 2/17/21.
//

import UIKit

class SearchProductTableViewCell: UITableViewCell {
    static let identifier = "SearchProductTableViewCell"
    @IBOutlet var productName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
