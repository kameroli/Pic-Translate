//
//  SwiftRecognitionViewController.swift
//  ClarifaiApiDemo
//

import UIKit
import CoreData
import XLActionController


/**
 * This view controller performs recognition using the Clarifai API.
 */

var arrayOfTags:[String]!

class SwiftRecognitionViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var translateButton: UIButton!
     var buttonClicked : Int!

    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Buttons
        translateButton.enabled = false
        translateButton.layer.borderWidth = 1.0
        translateButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(1.0).CGColor
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(1.0).CGColor
        
        //Custom navigationBar
        
        navigationController?.navigationBar.translucent = false
        
        navigationController?.navigationBar.titleTextAttributes = ([NSFontAttributeName: UIFont(name: "Montserrat", size: 20)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRectMake(0, 0, navigationController!.navigationBar.bounds.size.width, navigationController!.navigationBar.bounds.size.height + 20)
        
        let startColor = UIColor(red: 255/255, green: 47/255, blue: 70/255, alpha: 1)
        let endColor = UIColor(red: 255/255, green: 165/255, blue: 70/255, alpha: 1)

        
        gradientLayer.colors =  [ startColor,endColor ].map{$0.CGColor}
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Render the gradient to UIImage
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Set the UIImage as background property
        navigationController!.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
    

        }
    
    
    @IBAction func actionSheetTest(sender: UIButton) {
        
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRectMake(0, 0, navigationController!.navigationBar.bounds.size.width, navigationController!.navigationBar.bounds.size.height + 20)
        
        let startColor = UIColor(red: 255/255, green: 47/255, blue: 70/255, alpha: 1)
        let endColor = UIColor(red: 255/255, green: 165/255, blue: 70/255, alpha: 1)
        
        gradientLayer.colors =  [ startColor,endColor ].map{$0.CGColor}
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Render the gradient to UIImage
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let actionController = TweetbotActionController()
        
        actionController.addAction(Action("Photo Library", style: .Default , handler: { action in
            actionController.dismissViewControllerAnimated(true, completion: {
                let picker = UIImagePickerController()
                picker.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
                picker.navigationBar.titleTextAttributes = ([NSFontAttributeName: UIFont(name: "Montserrat", size: 20)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
                
                picker.navigationBar.tintColor = UIColor.whiteColor()
                picker.sourceType = .PhotoLibrary
                picker.allowsEditing = false
                picker.delegate = self
                self.presentViewController(picker, animated: true, completion: nil)
            })
            
        }))
        
    
        actionController.addAction(Action("Take Photo", style: .Default, handler: {action in
            actionController.dismissViewControllerAnimated(true, completion: {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                let picker = UIImagePickerController()
                picker.sourceType = .Camera
                picker.cameraDevice = .Rear
                picker.allowsEditing = false
                picker.delegate = self
                self.presentViewController(picker, animated: true, completion: nil)
                }else{
                    print("Device not available")
                }
            })
            
        
        
        }))
        
        actionController.addSection(Section())
        actionController.addAction(Action("Cancel", style: .Cancel, handler:nil))
        
       presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func buttonPressed(sender: UIButton) {
        // Show a UIImagePickerController to let the user pick an image from their library.
        buttonClicked = 1
        
        actionSheetTest(sender)
        
    }
    

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // The user picked an image. Send it to Clarifai for recognition.
            imageView.image = image
            textView.text = "Recognizing..."
            button.enabled = false
            recognizeImage(image)
        }
    }
    private func recognizeImage(image: UIImage!) {
        // Scale down the image. This step is optional. However, sending large images over the
        // network is slow and does not significantly improve recognition performance.
        print(image.size.width)
        print(image.size.height)
        
        let size = CGSizeMake(380, 320 * image.size.height / image.size.width)   //size 380, 320
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Encode as a JPEG.
        let jpeg = UIImageJPEGRepresentation(scaledImage!, 0.9)!

        // Send the JPEG to Clarifai for standard image tagging.
        client.recognizeJpegs([jpeg]) {
            (results: [ClarifaiResult]?, error: NSError?) in
            if error != nil {
                print("Error: \(error)\n")
                self.textView.text = "Sorry, there was an error recognizing your image."
                self.translateButton.enabled = false
            } else {
                self.textView.text = "\n" + results![0].tags.joinWithSeparator(", ")
                arrayOfTags = results![0].tags
                self.translateButton.enabled = true
                
                
            }
            self.button.enabled = true
        }
        
    
  
    }
    
    
    
}
