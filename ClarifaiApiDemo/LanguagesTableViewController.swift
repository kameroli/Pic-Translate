//
//  LanguagesTableViewController.swift
//  Pic+Translate
//
//  Created by Melissa Rojas on 9/11/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit
import CoreData

struct SectionData {
    let title: String
    let data:[(long:String, short:String)]
    
    var numberOfItems: Int {
        return data.count
    }
    
    subscript(index: Int) -> (String,String) {
        return data[index]
    }
}

extension SectionData{
    init(title: String, data: (long:String,short:String)...){
        self.title = title
        self.data = data
    }
}


var recentLanguagesArray: [(long:String, short:String)] = []

//class LanguagesTableViewController: UITableViewController {
    
class LanguagesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    
    lazy var mySections:[SectionData] = {
        let section1 = SectionData(title: "Recent Languages", data: recentLanguagesArray)
        var section2 = SectionData(title: "Select Languages", data: [("English","en"), ("Spanish","es"), ("Chinese","zh")])
        
        return [section1, section2]

    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print(mySections.count)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section].title
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mySections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySections[section].numberOfItems
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellTitle = mySections[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = cellTitle.0
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let LanguageName = mySections[(indexPath.section)][(indexPath.row)] as (long:String, short:String)
        
        selectedLanguage = LanguageName.short

        recentLanguagesArray.append((long: (LanguageName.long), short: (LanguageName.short)))
        
        let tmpController = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) {
            tmpController?.dismissViewControllerAnimated(true, completion: nil)
            
        }

        
   
                
    }
    

}
