//
//  ViewController.swift
//  XPIRE
//
//  Created by Mando Quintana on 2/10/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var expiringTableView: UITableView!
    @IBOutlet var headerLabel: UILabel!
    var expiringProducts = [SavedProduct]()
    
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?
    .persistentContainer.viewContext
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateUser()
        expiringTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expiringProducts = getExpiringFoods()
        expiringTableView.reloadData()
    }
    
    /* if app is loaded for the very first time, we create a user core data object
     to store data. If not, we simply fetch and reload the users data
     */
    func instantiateUser(){
        do {
            user = try loadUser()
        }
        catch UserExceptions.noUserFound {
            let newUser = User(context: context)
            newUser.default_storage_method = "Fridge"
            newUser.notifications = [String: [String]]()
            newUser.reminder_freq = 5
            newUser.saved_products = [SavedProduct]()
            newUser.total_points = 0
            do{
                try self.context.save()
                user = newUser
            }
            catch{
                print(error.localizedDescription)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        expiringProducts = getExpiringFoods()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expiringProducts.count == 0 {
            tableView.setEmptyView(title: "No expiring products to display within the set reminder frequency of \(getReminderFrequency()) days.", message: "You can add more products by clicking on the Search Products tab below or change the default notification frequency in the settings!", titleColor: UIColor.white, msgColor: UIColor.white, messageImage: #imageLiteral(resourceName: "down-arrow"))
        } else {
            tableView.restore()
        }
        
        return expiringProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpiringFoodTableViewCell", for: indexPath) as! ExpiringFoodTableViewCell
        
        let shortName = expiringProducts[indexPath.row].splitProductNameAndDetails()[0]
        cell.foodNameLabel.text = "\(shortName) (\(getDaysBeforeExpiration(product: expiringProducts[indexPath.row])))"
        return cell
    }
}


