//
//  ImageWordsTableViewController.swift
//  ClarifaiApiDemo
//
//  Created by Melissa Rojas on 5/10/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit
import CoreData

class ImageWordsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var chooseLanguageButton: UIButton!
    
    @IBOutlet weak var availableLanguages: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        availableLanguages.image = UIImage(named: "Language")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTags.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "WordsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WordsTableViewCell

        let word = arrayOfTags[indexPath.row]
        
        cell.wordLabel.text = word
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! WordsTableViewCell
                
        currentCell.translateWordAnyLanguage()
       
    }
    
 
    @IBAction func displayAvailableLanguages(sender: UIBarButtonItem) {
        
    
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.view.addSubview(blurEffectView)
        self.performSegueWithIdentifier("showLanguages", sender: self)
        
        
        
    }
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLanguages"{
            
            let vc = segue.destinationViewController 
            
            let controller = vc.popoverPresentationController
            
            
            if controller != nil{
                controller?.delegate = self
                controller?.permittedArrowDirections = .Up
                

            }
        }
    }
    

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
