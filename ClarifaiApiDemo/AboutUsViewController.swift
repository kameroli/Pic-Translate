//
//  AboutUsViewController.swift
//  Pic+Translate
//
//  Created by Melissa Rojas on 9/7/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    
    @IBOutlet weak var aboutTextView: UITextView!
    
    
    override func viewDidLoad() {
        
     aboutTextView.text = "Pic + Translate is an app created to help people who want to increase their english vocabulary by indentifying the content of pictures and describing them with words that will be translated into the language chosen"
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func openLink(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string:"http://translate.yandex.com/")!)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
