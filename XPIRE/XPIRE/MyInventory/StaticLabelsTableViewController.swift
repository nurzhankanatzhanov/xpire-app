//
//  StaticLabelsTableViewController.swift
//  XPIRE
//
//  Created by Mando Quintana on 3/24/21.
//

import UIKit

class StaticLabelsTableViewController: UITableViewController {
    var item: SavedProduct?
    var labelsToDisplay = [NSMutableAttributedString]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StaticLabelsTableViewCell", bundle: nil), forCellReuseIdentifier: "StaticLabelsTableViewCell")
    
        labelsToDisplay = [
            NSMutableAttributedString()
                .normal("Storage Method: ")
                .bold(("\(item?.storage ?? "unknown")")),
            NSMutableAttributedString()
                .normal("Purchase Date: ")
                .bold("\(item?.stringifyPurchasedDate(shortenDate: false) ?? "unknown")"),
            NSMutableAttributedString()
                .normal("Expiration Date: ")
                .bold("\(item?.stringifyExpirationDate(shortenDate: false) ?? "unknown")")
        ]
        
        tableView.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return labelsToDisplay.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaticLabelsTableViewCell", for: indexPath) as! StaticLabelsTableViewCell
        
        cell.staticTextLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cell.staticTextLabel.attributedText = labelsToDisplay[indexPath.row]
        cell.staticTextLabel.adjustsFontForContentSizeCategory = true
        return cell
    }
}
