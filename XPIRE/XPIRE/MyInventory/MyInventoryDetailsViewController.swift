//
//  MyInventoryDetailsViewController.swift
//  XPIRE
//
//  Created by Mando Quintana on 3/1/21.
//

import UIKit
import AVFoundation

class MyInventoryDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var product: SavedProduct?
    var indexPath: Int!
    @IBOutlet weak var deleteProductButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tipsTableView: UITableView!
    @IBOutlet var productDescription: UILabel!
    @IBOutlet var deleteButton: UIButton!
    var audioPlayer = AVAudioPlayer()
    var badAudioPlayer = AVAudioPlayer()
    
    var results = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipsTableView.rowHeight = UITableView.automaticDimension
        tipsTableView.estimatedRowHeight = 600
        deleteProductButton.titleLabel?.adjustsFontForContentSizeCategory = true
        setUpUI()
        prepareGoodSound()
        prepareBadSound()
    }
    
    func prepareGoodSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "impressed", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func prepareBadSound() {
        do {
            badAudioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "case-closed", ofType: "mp3")!))
            badAudioPlayer.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func setUpUI(){
        guard let productToDisplay = product else { return }
        
        let (productName, productDesc) = splitProductNameAndDescription(fullName: productToDisplay.name)
        
        nameLabel.text = productName
        productDescription.text = productDesc
    }
    
    @IBAction func didPressDelete(_ sender: Any) {
        //deleteProduct(index: indexPath)
        createProductConsumptionActionSheet()
    }
    
    func createProductConsumptionActionSheet(){
        let alertController = UIAlertController(title: nil, message: nil,  preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes 😋", style: .default) { (_) in
            deleteProduct(index: self.indexPath)
            updateTotalPoints(pointAmount: 10)
            self.createUIAlertResponse(title: "Amazing, thanks for not wasting food!", message: "You have earned +10 points!")
            deleteAllNotifications(itemToDelete: self.product!.item_id)
            self.audioPlayer.play()
        }
       
        let noAction = UIAlertAction(title: "No 😭", style: .default) { (_) in
            deleteProduct(index: self.indexPath)
            updateTotalPoints(pointAmount: -10)
            self.createUIAlertResponse(title: "It’s okay, make sure to dispose food properly!", message: "You have lost -10 points!")
            deleteAllNotifications(itemToDelete: self.product!.item_id)
            self.badAudioPlayer.play()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let productToDisplay = product else { return 0 }
        
        let count = productToDisplay.tips.count
        if count == 0 {
            tableView.setEmptyView(title: "There are no storage tips for this specific product.", message: "Please be mindful of this product's expiration!", titleColor: UIColor.black, msgColor: UIColor.lightGray, bottomConstant: 20.0)
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyInventoryDetailsTableViewCell") as! MyInventoryDetailsTableViewCell
        guard let productToDisplay = product else { return cell }
        cell.tipLabel.text = productToDisplay.tips[indexPath.row]
        return cell
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "StaticLabelsTableViewController" {
            let customView = segue.destination as! StaticLabelsTableViewController
            customView.item = product
        }
        
        if segue.identifier == "RecipesTableViewController" {

            let customView = segue.destination as! RecipesTableViewController
            customView.productName = nameLabel.text!
        }
    }
}
