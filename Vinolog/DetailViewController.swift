//
//  DetailViewController.swift
//  Vinolog
//
//  Created by Andrew Conrad on 5/19/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    static let sharedInstance = DetailViewController()
    let wineTableViewController = WineTableViewController.sharedInstance
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
            selectedWine!.wineName = " '\(wineNameTextField.text)'"
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
            

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

