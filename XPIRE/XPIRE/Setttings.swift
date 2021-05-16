//
//  Setttings.swift
//  XPIRE
//
//  Created by Anderson Gonzalez on 3/8/21.
//
import UserNotifications
import UIKit
import CoreData

class SettingsViewController:UITableViewController, UNUserNotificationCenterDelegate{
    
    @IBOutlet weak var seg_control: UISegmentedControl!
    
    @IBOutlet weak var valueLabel: UILabel!
    
   
    @IBOutlet weak var levelText: UILabel!
    
    @IBOutlet weak var levelMesg: UILabel!
    
    @IBOutlet weak var theSlider: UISlider!
    
    @IBOutlet weak var levelIcon: UILabel!
    
   //data containers for pickers
    var methods : [String] = [String]()
    var days : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getStorageDefault()
        getFrequencyDefault()
        setLevel()
    }
    
   
    
    @IBAction func defaulStorageChanged(_ sender: Any) {
        var method = ""
        
        switch seg_control.selectedSegmentIndex {
        case 0:
            method = "Pantry"
        case 1:
            method = "Fridge"
        case 2:
            method = "Freezer"
        default :
            break
            
        }
       saveDefaultStore(defaultMethod: method)
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let sliderTrueValue = Int(sender.value)*1
        valueLabel.text = sliderTrueValue.description
        saveFrequency(defaultFreq: Int32(sender.value))
        frequencyChangedNotifications()
        
    }
    
    
   
    
 
    // pulling the Core Data Storage Default attribute of a User
    public func getStorageDefault(){
        seg_control.defaultConfiguration()
       let storage_default = getStorageMethod()
       
        var defaultIndex = 0
        
        switch (storage_default){
        case "Pantry":
            defaultIndex = 0
        case "Fridge":
            defaultIndex = 1
            // the API call returns "Refrigerator" as a location, but we use "Fridge" throughout the app so need to change the String
            //defaultStorageMethod = "Refrigerator"
        case "Freezer":
            defaultIndex = 2
        default:
            defaultIndex = 0
        }
        
        seg_control.selectedSegmentIndex = defaultIndex;
        seg_control.selectedConfiguration()
    }
    
    public func getFrequencyDefault(){
       let defaultFreq = getReminderFrequency()
        
        //set proper slider properties
        theSlider.maximumValue = 7
        theSlider.minimumValue = 1
        
        //slider value
        let float_defaultFreq =  Float(defaultFreq)
        theSlider.setValue(float_defaultFreq, animated: true)
        
        //set Label to represent default
        valueLabel.text = defaultFreq.description
    }
    
    public func saveDefaultStore(defaultMethod:String) {
        
        var context: NSManagedObjectContext!{
            return (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer.viewContext
        }
        do {
            user = try loadUser()
            user.default_storage_method = defaultMethod
            try context.save()
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    public func saveFrequency(defaultFreq:Int32) {
        
        var context: NSManagedObjectContext!{
            return (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer.viewContext
        }
        do {
            user = try loadUser()
            user.reminder_freq = defaultFreq
            try context.save()
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    public func setLevel(){
        do{
            let theUserPoints = try getTotalPoints()
            let result = getSkillLevel(totalPoints: theUserPoints)
            let skillName = result.name
            let skillNumber = result.number
            let skillDes = result.description
            let skillBadge = result.badge
            
            levelIcon.text =  skillBadge 
            
            levelText.text =  "Level " + String(skillNumber) + ":" + skillName
            levelMesg.text = skillDes
        }catch{
              print("There was an error with getthing the points")
        }
    }
    
    
 
}

extension UISegmentedControl
{
    func defaultConfiguration(color: UIColor = UIColor.white)
    {
        let defaultAttributes = [
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(color: UIColor = UIColor.black)
    {
        let selectedAttributes = [
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
