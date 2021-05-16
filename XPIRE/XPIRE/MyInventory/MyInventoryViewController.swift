//
//  MyInventoryViewController.swift
//  XPIRE
//
//  Created by Mando Quintana on 3/1/21.
//

import UIKit
import CoreData
class MyInventoryViewController: UIViewController, UITableViewDataSource{
    @IBOutlet var inventoryTableView: UITableView!
    @IBOutlet var addMoreItemsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //inventoryTableView()
        inventoryTableView.rowHeight = UITableView.automaticDimension
        inventoryTableView.estimatedRowHeight = 600
        addMoreItemsButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchInventory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        inventoryTableView.isEditing = false;
    }

    
    func fetchInventory(){
        inventory = getUserInventory()
        inventoryTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inventory.count == 0 {
            tableView.setEmptyView(title: "You do not have any products saved in your inventory.", message: "You can add more products by pressing on the button below!", titleColor: UIColor.white, msgColor: UIColor.white, messageImage: #imageLiteral(resourceName: "down-arrow"))
        } else {
            tableView.restore()
        }
        
        return inventory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyItemTableViewCell") as! MyItemTableViewCell
        let nameSubstrings = inventory[indexPath.row].splitProductNameAndDetails()
        cell.nameLabel.text = nameSubstrings[0]
        cell.expiringDate.text = "Expiring: \(inventory[indexPath.row].stringifyExpirationDate(shortenDate: false))"
        cell.purchasedDate.text = "Purchased: \(inventory[indexPath.row].stringifyPurchasedDate(shortenDate: false))"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyInventoryDetails" {
            let cell = sender as! UITableViewCell
            guard let indexPath = inventoryTableView.indexPath(for: cell) else { return }
            let selectedProduct = inventory[indexPath.row]
            let view = segue.destination as! MyInventoryDetailsViewController
            view.product = selectedProduct
            view.indexPath = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //swipe to delete
        //UITableViewCell.EditingStyle
        if editingStyle == .delete {
            createProductConsumptionActionSheet(indexPath: indexPath)
        }
    }
    
    @IBAction func didTapEdit() {
        if inventoryTableView.isEditing {
            inventoryTableView.isEditing = false
        }
        else {
            inventoryTableView.isEditing = true
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        inventory.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        updateInventory(inventory: inventory)
        fetchInventory()
    }
    
    func createProductConsumptionActionSheet(indexPath: IndexPath){
        let alertController = UIAlertController(title: nil, message: nil,  preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes 😋", style: .default) { (_) in
            deleteAllNotifications(itemToDelete: inventory[indexPath.row].item_id)
            deleteProduct(index: indexPath.row)
            updateTotalPoints(pointAmount: 10)
            self.createUIAlertResponse(title: "Amazing, thanks for not wasting food!", message: "You have earned +10 points!")
            self.fetchInventory()
        }
       
        let noAction = UIAlertAction(title: "No 😭", style: .default) { (_) in
            deleteAllNotifications(itemToDelete: inventory[indexPath.row].item_id)
            deleteProduct(index: indexPath.row)
            updateTotalPoints(pointAmount: -10)
            self.createUIAlertResponse(title: "It’s okay, make sure to dispose food properly!", message: "You have lost -10 points!")
            self.fetchInventory()
        }
        noAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        let titleAttrString = NSMutableAttributedString(string: "Did you consume this product before its expiration?", attributes: titleFont)

        alertController.setValue(titleAttrString, forKey:"attributedTitle")
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        alertController.addAction(cancel)
    
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createUIAlertResponse(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let done = UIAlertAction(title: "Done", style: .destructive){ (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(done)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // sort the tableview cells alphabetically
    func sortAlphabetically() {
        inventory = getUserInventory()
        inventory.sort {
            $0.name < $1.name
        }
        updateInventory(inventory: inventory)
        inventoryTableView.reloadData()
    }
    
    // sort by closest to expiration first
    func sortByExpirationDate() {
        inventory = getUserInventory()
        inventory.sort {
            $0.expirationDate < $1.expirationDate
        }
        updateInventory(inventory: inventory)
        inventoryTableView.reloadData()
    }
    
    // sort by specified storage method
    func sortByStorageMethod() {
        inventory = getUserInventory()
        inventory.sort {
            $0.storage > $1.storage
        }
        updateInventory(inventory: inventory)
        inventoryTableView.reloadData()
    }
    
    func createSortByActionSheet(){
        let alertController = UIAlertController(title: nil, message: nil,  preferredStyle: .actionSheet)
        
        let alphabeticallyAction = UIAlertAction(title: "Alphabetically", style: .default) { (_) in
            self.sortAlphabetically()
        }
       
        let expirationAction = UIAlertAction(title: "By Expiration Date", style: .default) { (_) in
            self.sortByExpirationDate()
        }
        
        let storageAction = UIAlertAction(title: "By Storage Method", style: .default) { (_) in
            self.sortByStorageMethod()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(alphabeticallyAction)
        alertController.addAction(expirationAction)
        alertController.addAction(storageAction)
        alertController.addAction(cancel)
    
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func didPressSort(_ sender: Any) {
        self.createSortByActionSheet()
    }
}
