//
//  LanguageViewController.swift
//  ClarifaiApiDemo
//
//  Created by Melissa Rojas on 7/31/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit
import CoreData

var selectedLanguage = "es"
var languageName = "Spanish"

class LanguageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var backAndSaveLanguageButton: UIButton!
    @IBOutlet weak var recentLanguagesTable: UITableView!
    @IBOutlet weak var languagePicker: UIPickerView!
    var pickerData: [(language: String, short: String)] = []
    var recentLanguagesStored:[(longName:String, shortName: String)] = []
    let languageCellIdentifier = "LanguageCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Modify view apparence
        /*self.view.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.layer.cornerRadius = 10
        self.view.layer.borderWidth = 0.5
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 1
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).CGPath*/

        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //Back button appareance
        backAndSaveLanguageButton.backgroundColor = UIColor(red: 251/255, green: 127/255, blue: 6/255, alpha: 1)
        
        //Connect data:
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        recentLanguagesTable.delegate = self
        recentLanguagesTable.dataSource = self
        
        loadDataIntoPicker()
        loadRecentLanguagesStored()
        
        
        
    }
    
    
    //Save selected language in Database
    @IBAction func saveSelectedLanguage(sender: UIButton) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        //Read data saved in database
        let request = NSFetchRequest(entityName: "RecentLanguages")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.executeFetchRequest(request)
            
            if results.count == 0 {
                
                print("Saving new Language because there is nothing in database")
                
                let newLanguage = NSEntityDescription.insertNewObjectForEntityForName("RecentLanguages", inManagedObjectContext: context)
                
                newLanguage.setValue(selectedLanguage, forKey: "language")
                newLanguage.setValue(languageName, forKey: "lanName")
                
                do{
                    try context.save()
                }catch{ // Save
                    print("Error Saving in database")
                }
                
            }else{
                
                //Adding a predicate to the request
                request.predicate = NSPredicate(format: "language = %@", selectedLanguage)
                request.returnsObjectsAsFaults = false
                
                do{
                    
                    let existingLanguage = try context.executeFetchRequest(request)
                    
                    if existingLanguage.count == 0 {
                        
                        print("Saving new language")
                        
                        let newLanguage = NSEntityDescription.insertNewObjectForEntityForName("RecentLanguages", inManagedObjectContext: context)
                        
                        newLanguage.setValue(selectedLanguage, forKey: "language")
                        newLanguage.setValue(languageName, forKey: "lanName")
                        
                        do{
                            try context.save()
                        }catch{
                            print("Error Saving in database")
                        }
                        
                        //Making sure the entity only has 3 languages stored
                        if results.count > 2 {
                            
                            print("There are more than 3 languages stored in the database")
                            
                                context.deleteObject((results.first)! as! NSManagedObject)
                            
                                do{
                                    try context.save()
                                }catch{
                                    print("there was a problem saving")
                                }
                 
                        }//Closing if results > 3
                        
                    }else{
                        print("Language already stored in database")
                        
                        for language in results as! [NSManagedObject]{
                            print(language.valueForKey("language")!)
                            print(language.valueForKey("lanName")!)
                        }
                        
                    }//Closing existingLanguage else
                    
                }catch{
                    print("Fetch failed")
                }
            }//Closing results else
            
        }catch{ //First do{}
            print("Fetch failed")
        }
        
        //Dismiss the LanguageViewController
        /*let tmpController = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) { 
            tmpController?.dismissViewControllerAnimated(false, completion: nil)
        }*/
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }//Save selected Language
    
    
    //Load languages into Picker
    func loadDataIntoPicker(){
        
        pickerData = [("Spanish", "es"), ("English", "en"), ("German", "de"), ("French", "fr"), ("Italian", "it"), ("Polish", "pl"), ("Portuguese", "pt"), ("Russian", "ru"), ("Japanese", "ja"), ("Chinese", "zh")]
        
    }
    
    //Show the recent languages stored in database
    func loadRecentLanguagesStored(){
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "RecentLanguages")
        
        request.returnsObjectsAsFaults = false
        
        do{
           let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                for result in results{
                    //recentLanguagesStored.append(result.valueForKey("language") as! String)
                    recentLanguagesStored.append((result.valueForKey("lanName") as! String, result.valueForKey("language") as! String))
                }
            }
        }catch{
            print("Fetch failed")
        }
        
        print(recentLanguagesStored)
        

        

    }
    
    
    func recentLanguageButtonPressed(sender: UIButton!){
        if sender.titleLabel?.text != nil{
            selectedLanguage = (sender.titleLabel?.text)!
            print("You have pressed: \((sender.titleLabel?.text)!)")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //The data to retunr for the row and component (column) that's beign passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].language
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        selectedLanguage = pickerData[row].short
        languageName = pickerData[row].language
        
        print(selectedLanguage)
    }
    
    
    //Tableview function prototypes
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentLanguagesStored.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(languageCellIdentifier, forIndexPath: indexPath)
        
        let row = indexPath.row
        
        cell.textLabel?.text = recentLanguagesStored[row].longName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       
        selectedLanguage = recentLanguagesStored[indexPath.row].shortName
        
        /*let tmpController = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) {
            tmpController?.dismissViewControllerAnimated(true, completion: nil)

        }*/
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
