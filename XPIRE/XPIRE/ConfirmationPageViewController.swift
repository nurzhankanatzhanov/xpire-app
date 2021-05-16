//
//  ConfirmationPageViewController.swift
//  XPIRE
//
//  Created by Mando Quintana on 3/15/21.
//

import UIKit

class ConfirmationPageViewController: UIViewController {
    var savedItem: SavedProduct?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var storageLabel: UILabel!
    @IBOutlet var purchaseLabel: UILabel!
    @IBOutlet var expirationLabel: UILabel!
    @IBOutlet var reminderLabel: UILabel!
    
    @IBOutlet weak var addMoreItemsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        createConfetti(view: self.view)
        addMoreItemsButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    func updateUI(){
        guard let productToDisplay = savedItem else { return }
        let (name, description) = splitProductNameAndDescription(fullName: productToDisplay.name)
        nameLabel.text = name
        descriptionLabel.text = description

        reminderLabel.attributedText = NSMutableAttributedString()
            .normal("You will be reminded about this product ")
            .boldAndUnderlined("\(getReminderFrequency()) days")
            .normal(" in advance of its expiration date!")
        reminderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        pointsLabel.attributedText = NSMutableAttributedString()
            .normal("You have earned ")
            .customGreen("+20 points")
            .normal(" for adding this item!")
        pointsLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationPageStaticLabels" {
            let customView = segue.destination as! StaticLabelsTableViewController
            customView.item = savedItem
        }
    }
}
