//
//  DetailViewController.swift
//  Vinolog
//
//  Created by Andrew Conrad on 5/19/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let loginManager = LoginManager.sharedInstance
    let backendless = Backendless.sharedInstance()
    var selectedWine : Wine?
    
    @IBOutlet weak var  wineNameTextField:      UITextField!
    @IBOutlet weak var  wineCategoryTextField:  UITextField!
    @IBOutlet weak var  wineVarietyTextField:   UITextField!
    @IBOutlet weak var  wineVintageTextField:   UITextField!
    @IBOutlet weak var  wineWineryTextField:    UITextField!
    @IBOutlet weak var  wineDateDrunkPicker:    UIDatePicker!
    @IBOutlet weak var  winePictureImageView:   UIImageView!
    @IBOutlet weak var  wineRatingSegControl:   UISegmentedControl!
    
    
    //MARK: - Save File Methods
    
    func getNewImageFilename () -> String {
        return NSProcessInfo.processInfo().globallyUniqueString + ".png"
    }
    
    func getDocumentPathForFile(filename: String) -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        print("Path: \(docPath)")
        return docPath.stringByAppendingPathComponent(filename)
    }
    
    //MARK: - Built In Camera Methods
    
    @IBAction func galleryBarButtonPressed(button: UIBarButtonItem) {
        print("Gallery")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .SavedPhotosAlbum
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraBarButtonPressed(button: UIBarButtonItem) {
        print("Camera Activated")
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            presentViewController(imagePicker, animated: true, completion:nil)
        } else {
            print("No Camera")
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Picked")
        winePictureImageView.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        selectedWine!.winePic = nil
        picker.dismissViewControllerAnimated(true, completion:nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Cancel")
        picker.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func rotateImage(image: UIImage) -> UIImage {
        if (image.imageOrientation == UIImageOrientation.Up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect(CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy
    }

    
    //MARK: - Save or Return

    
    func saveWine(wine: Wine) {
        let dataStore = backendless.data.of(Wine.ofClass())
        dataStore.save(wine, response: { (response) in
            print("Wine Saved")
        }) { (error) in
            print("Wine not saved, error \(error)")
        }
    }
    
    @IBAction func saveBarButtonPressed(sender: UIBarButtonItem) {
        if wineNameTextField.text!.characters.count > 0 {
            selectedWine!.wineName = "\(wineNameTextField.text!)"
            selectedWine!.wineCategory = "\(wineCategoryTextField.text!)"
            selectedWine!.winVariety = "\(wineVarietyTextField.text!)"
            selectedWine!.wineVintage = "\(wineVintageTextField.text!)"
            selectedWine!.wineWinery = "\(wineWineryTextField.text!)"
            selectedWine!.wineDateDrunk = wineDateDrunkPicker.date
            if let image = winePictureImageView.image {
                if selectedWine!.winePic == nil || selectedWine!.winePic == "" {
                    let filename = getNewImageFilename()
                    let imagePath = getDocumentPathForFile(filename)
                    let imageRotated = rotateImage(image)
                    UIImagePNGRepresentation(imageRotated)!.writeToFile(imagePath, atomically: true)
                    selectedWine!.winePic = filename
                }
            } else {
                print("No Image to Save")
            }
            
            selectedWine!.wineRating = wineRatingSegControl.selectedSegmentIndex
        self.navigationController!.popViewControllerAnimated(true)
            saveWine(selectedWine!)
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedWine == nil {
            let newWine = Wine()
            newWine.wineName = ""
            newWine.wineCategory = ""
            newWine.winVariety = ""
            newWine.wineVintage = ""
            newWine.wineWinery = ""
            newWine.wineRating = 1
            newWine.wineDateDrunk = NSDate.init(timeIntervalSinceNow: 1)
            newWine.winePic = ""
            selectedWine = newWine
        } else {
            wineNameTextField.text = selectedWine!.wineName
            wineCategoryTextField.text = selectedWine!.wineCategory
            wineVarietyTextField.text = selectedWine!.winVariety
            wineVintageTextField.text = selectedWine!.wineVintage
            wineWineryTextField.text = selectedWine!.wineWinery
            wineDateDrunkPicker.date = selectedWine!.wineDateDrunk
            wineRatingSegControl.selectedSegmentIndex = selectedWine!.wineRating
            if let filename = selectedWine!.winePic {
                winePictureImageView.image = UIImage(named: getDocumentPathForFile(filename))
            }

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

