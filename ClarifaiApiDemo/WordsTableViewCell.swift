//
//  WordsTableViewCell.swift
//  ClarifaiApiDemo
//
//  Created by Melissa Rojas on 5/9/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit
import CoreData
import FlourishUI

class WordsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var wordLabel: UILabel!
    
    let yandexKey: String = "trnsl.1.1.20160728T175712Z.0e8df3f65ab5ae04.764dc3ff4b0fff581c27d03dc3c170b696c50dee"
    
    var myWord : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
 

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
    //Translate a word by making a REST API call to "Yandex Translate API"
    func translateWordAnyLanguage(){
        
        
        var wordInOtherLanguage : String!
        
        let wordToTranslate = wordLabel.text!.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        var languageToTranslate = ""
        
        if selectedLanguage != "" {
             languageToTranslate = "&lang=en-" + selectedLanguage
        }else{
             languageToTranslate = "&lang=en-es"
        }
        
        let endPointYandex = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=" + yandexKey + languageToTranslate + "&text=" + wordToTranslate
        
        let url = NSURL(string: endPointYandex)!
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url) { data, response, error in
            
              guard let realResponse = response as? NSHTTPURLResponse where
            realResponse.statusCode == 200 else{
                print("Not a 200 response")
                return
            }
            
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                
                if let translatedW = json!["text"] as? [String]{
                    print(translatedW.count)
                    
                    if translatedW.count > 1{
                        wordInOtherLanguage = translatedW.joinWithSeparator(" ")}else{
                        wordInOtherLanguage = translatedW.first
                   
                    }
                }
                
               
                
            }catch{
                print(error)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                
                Modal(title: self.wordLabel.text! , body: "________________\n\n" + wordInOtherLanguage + "\n", status: .Success).show()
                

             })
            
      
        }
            task.resume()
        
    }
    
    

}
