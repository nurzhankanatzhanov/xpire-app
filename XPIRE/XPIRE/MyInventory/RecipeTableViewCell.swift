//
//  RecipeTableViewCell.swift
//  XPIRE
//
//  Created by Mando Quintana on 4/23/21.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
