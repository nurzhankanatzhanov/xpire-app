//
//  ItemDetailViewController.swift
//  XPIRE
//
//  Created by Mando Quintana on 2/22/21.
//

import UIKit
import CoreData
import AVFoundation

class ItemDetailViewController: UIViewController, UNUserNotificationCenterDelegate {
    var item: Product?
    var guide: ProductGuide?
    var availableMethods = [String: StorageMethods]()
    var itemToSave: SavedProduct!
    @IBOutlet var addProductButton: UIButton!
    
    var notifData = [String:[String]]()
    
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productConditionLabel: UILabel!
    @IBOutlet var expirationLabel: UILabel!
    @IBOutlet var methodsSegmentedControl: UISegmentedControl!
    @IBOutlet var purchasedDatePicker: UIDatePicker!
    @IBOutlet var expirationDatePicker: UIDatePicker!
    
    // global Core Data context
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?
    .persistentContainer.viewContext
    }
    
    var audioPlayer = AVAudioPlayer()
    
    // upon loading of the view, fetch the guide for that item, updating the UI
    override func viewDidLoad() {
        super.viewDidLoad()
        let ID = String(item!.id)
        fetchItemGuide(guideID: ID)
        prepareSound()
        addProductButton.titleLabel?.adjustsFontForContentSizeCategory = true
        expirationDatePicker.center = .init(x: 50, y: 50)
    }
    
    // main API call to fetch the specific item info from the Shelf API given an item ID
    func fetchItemGuide(guideID: String){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "shelf-life-api.herokuapp.com"
        urlComponents.path = "/guides/"
        let url = URL(string: "https://shelf-life-api.herokuapp.com/guides/\(guideID)")
        
        URLSession(configuration: .default).dataTask(with: url!) {data,response, error in
            if let data = data {
                do {
                    self.guide = try JSONDecoder().decode(ProductGuide.self, from: data)
                } catch let error {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }.resume()
    }
    
    // update the UI for product name and description and populate the available storage methods
    func updateUI(){
        guard let guide = guide else { return }
        let name = guide.name
        
        let (productName, conditionLabel) = splitProductNameAndDescription(fullName: name)
        
        // update the labels for product and description
        productNameLabel.text = productName
        productConditionLabel.text = conditionLabel
        
        guide.methods.forEach { (storageMethod) in
            availableMethods.updateValue(storageMethod, forKey: storageMethod.location)
        }
        
        // set up default storage method + labels
        setUpDefaultStorage()
    }
    
    /* Checks to see if there segement has changed. Options are "Pantry," "Fridge", or "Freezer"
       If the segement has changed, then we want the current date from the purchased date picker.
       Next we check the selected segement and see if that specific storage method was returned by the api.
       If so, then update the expiration date picker with the api expiration date plus the current date. If not,
       then just allow the user to set any expiration date and display "no recommended date found"
     */
    @IBAction func SegmentDidChange(_ sender: Any) {
        let index = methodsSegmentedControl.selectedSegmentIndex

        var method = ""

        switch (index) {
        case 0:
            method = "Pantry"
        case 1:
            method = "Refrigerator"
        case 2:
            method = "Freezer"
        default:
            method = "Pantry"
        }
        
        // update the expiration label
        setUpStorageLabels(method: method)
    }
    
    @IBAction func purchasedDateDidChange(_ sender: Any) {
        SegmentDidChange(purchasedDatePicker.date)
    }
    
    @IBAction func addProductPressed(_ sender: Any) {
        let storageName = methodsSegmentedControl.titleForSegment(at: methodsSegmentedControl.selectedSegmentIndex)!
        guard let productTips = guide?.tips else { return }
        
        itemToSave = SavedProduct(
            name: item!.name,
            tips: productTips,
            storage: storageName,
            purchasedDate: purchasedDatePicker.date,
            expirationDate: expirationDatePicker.date,
            item_id: UUID().uuidString
        )
        
        // save product after "Add" is pressed, update the total point tally (increase by 20) and request notifications if this is the very first time
        saveProduct(productToSave: itemToSave)
        updateTotalPoints(pointAmount: 20)
        requestNotificationPersmission(item: itemToSave)
        
        // play the sound
        audioPlayer.play()
        
        _ = getExpiringFoods()
    }
    
    // pre-buffer the audio player for when the view loads
    func prepareSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "short_sms", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationPage" {
            let view = segue.destination as! ConfirmationPageViewController
            view.savedItem = itemToSave
        }
    }
    
    // set up the default storage segmented control on the load of the page (during UI update)
    func setUpDefaultStorage() {
        // set up the default value of the segmented control based on Core Data - saved default storage method
        var defaultStorageMethod = getStorageMethod()
        var defaultIndex = 0
        
        switch (defaultStorageMethod){
        case "Pantry":
            defaultIndex = 0
        case "Fridge":
            defaultIndex = 1
            // the API call returns "Refrigerator" as a location, but we use "Fridge" throughout the app so need to change the String
            defaultStorageMethod = "Refrigerator"
        case "Freezer":
            defaultIndex = 2
        default:
            defaultIndex = 0
        }
        
        // set up the default index
        self.methodsSegmentedControl.selectedSegmentIndex = defaultIndex
        
        // update the expiration labels
        setUpStorageLabels(method: defaultStorageMethod)
    }
    
    // set up the expiration labels for each segmented control based on the API response
    func setUpStorageLabels(method: String) {
        let currentDate = purchasedDatePicker.date
        // set up labels for the given storage method depending on the selected segment
        if let storageMethod = availableMethods[method]{
            expirationLabel.text = "Recommended Expiration: \(storageMethod.expiration)"
            let modifiedDate = currentDate.advanced(by: TimeInterval(storageMethod.expirationTime))
            expirationDatePicker.setDate(modifiedDate, animated: true)
        } else {
            expirationLabel.text = "No Recommended Expiration"
        }
    }
}
