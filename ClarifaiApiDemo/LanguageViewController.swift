//
//  LanguageViewController.swift
//  ClarifaiApiDemo
//
//  Created by Melissa Rojas on 7/31/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit
import CoreData

var selectedLanguage : String = String()
var languageName = "English"

class LanguageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var backAndSaveLanguageButton: UIButton!
    @IBOutlet weak var recentLanguagesTable: UITableView!
    @IBOutlet weak var languagePicker: UIPickerView!
    var pickerData: [(language: String, short: String)] = []
    var recentLanguagesStored:[(longName:String, shortName: String)] = []
    var showRecentLanguages:[(longName:String, shortName: String)] = []
    let languageCellIdentifier = "LanguageCell"
    var pickerSelected = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        //Hide Navigation back button
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
        
        languagePicker.selectRow(11, inComponent: 0, animated: false)
        showRecentLanguages = recentLanguagesStored.reverse()
     
    }
    

    @IBAction func cancelButtonClicked(sender: AnyObject) {
        
     self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //Save selected language in Database
    @IBAction func saveSelectedLanguage(sender: UIButton) {
        
        selectedLanguage = pickerSelected
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        //Read data saved in database
        let request = NSFetchRequest(entityName: "RecentLanguages")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.executeFetchRequest(request)
            
            if results.count == 0 {
                
                //Saving new Language because there is nothing in database
                
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
                        
                        //Saving new language
                        
                        let newLanguage = NSEntityDescription.insertNewObjectForEntityForName("RecentLanguages", inManagedObjectContext: context)
                        
                        newLanguage.setValue(selectedLanguage, forKey: "language")
                        newLanguage.setValue(languageName, forKey: "lanName")
                        
                        do{
                            try context.save()
                        }catch{
                            print("Error Saving in database")
                        }
                        
                        //Making sure the entity only has 3 languages stored
                        if results.count > 3 {
                            
                            //There are more than 3 languages stored in the database
                            
                                context.deleteObject((results.first)! as! NSManagedObject)
                            
                                do{
                                    try context.save()
                                }catch{
                                    print("there was a problem saving")
                                }
                 
                        }//Closing if results > 3 ....For testing purposes, add an else statement
                        
                    }
                    
                }catch{
                    print("Fetch failed")
                }
            }//Closing results else
            
        }catch{ //First do{}
            print("Fetch failed")
        }
        
        //Saving languge for next time user uses the app
        NSUserDefaults.standardUserDefaults().setObject(selectedLanguage, forKey: "lastLanguage")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }//Save selected Language
    
    
    //Load languages into Picker
    func loadDataIntoPicker(){
        
        pickerData = [("Albanian","sq"),("Arabic","ar"),("Armenian","hy"), ("Belarusian","be"), ("Bulgarian","bg"), ("Bosnian","bs"), ("Chinese", "zh"), ("Croatian","hr"), ("Czech","cs"), ("Dutch","nl"), ("Danish","da"), ("English", "en"), ("Estonian","et"),  ("French", "fr"), ("Finnish","fi"), ("German", "de"), ("Greek","el"), ("Georgian","ka"), ("Hebrew","he"), ("Hungarian","hu"), ("Indonesian","id"), ("Italian", "it"), ("Japanese", "ja"), ("Korean","ko"), ("Lithuanian","lt"), ("Maltese","mt"), ("Mongolian","mn"), ("Nepali","ne"), ("Norwegian","no"), ("Polish", "pl"), ("Portuguese", "pt"), ("Romanian","ro"), ("Russian", "ru"), ("Serbian","sr"), ("Slovakian","sk"), ("Slovenian","sl"), ("Spanish", "es"), ("Swedish","sv"),  ("Thai","th"), ("Turkish","tr"), ("Ukrainian","uk"), ("Vietnamese","vi") ]
        
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
                    recentLanguagesStored.append((result.valueForKey("lanName") as! String, result.valueForKey("language") as! String))
                }
            }
        }catch{
            print("Fetch failed")
        }
        
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
    
    //The data to return for the row and component (column) that's beign passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].language
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        //selectedLanguage = pickerData[row].short
        pickerSelected = pickerData[row].short
        languageName = pickerData[row].language
        
    }
    
    
    //Tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentLanguagesStored.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(languageCellIdentifier, forIndexPath: indexPath) as! RecentLanguageTableViewCell
        
        let row = indexPath.row
        
        cell.languageLabel.text = showRecentLanguages[row].longName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       
        selectedLanguage = showRecentLanguages[indexPath.row].shortName
        
        //Saving languge for next time user uses the app
        NSUserDefaults.standardUserDefaults().setObject(selectedLanguage, forKey: "lastLanguage")
        NSUserDefaults.standardUserDefaults().synchronize()
        
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
