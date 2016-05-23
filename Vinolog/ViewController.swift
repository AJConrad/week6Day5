//
//  ViewController.swift
//  Vinolog
//
//  Created by Andrew Conrad on 5/19/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static let sharedInstance = ViewController()
    var loginManager = LoginManager.sharedInstance
    let backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var      emailEntryTextField         :UITextField!
    @IBOutlet weak var      passwordEntryTextField      :UITextField!
    @IBOutlet weak var      registerButton              :UIBarButtonItem!
    @IBOutlet weak var      loginButton                 :UIBarButtonItem!
    


    
    //MARK: - User Login Verification Methods
    
    //bare minimum what a email and password could be method
    private func isValidLogin(email: String, password: String) -> Bool {
        return email.characters.count > 5 && password.characters.count > 3
    }
    
    //method that unlocks the buttons when the bare minimum requirements happen
    @IBAction private func entryFieldsChanged() {

        
        guard let email = emailEntryTextField.text else {
            return
        }
        guard let password = passwordEntryTextField.text else {
            return
        }
        if isValidLogin(email, password: password) {
            registerButton.enabled = true
            loginButton.enabled = true
        }
    }
    
    
    
    //MARK: - Interactivity Methods
    
    @IBAction private func registerUserBarButton(button: UIBarButtonItem) {
        guard let email = emailEntryTextField.text else {
            return
        }
        guard let password = passwordEntryTextField.text else {
            return
        }
        loginManager.registerNewUser(email, password: password)
    }
    
    func regSuccess() {
        performSegueWithIdentifier("Register", sender: self)
    }
    
    func regFail() {
        print("is not logged in")
    }
    
    @IBAction private func loginUserBarButton(button: UIBarButtonItem) {
        guard let email = emailEntryTextField.text else {
            return
        }
        guard let password = passwordEntryTextField.text else {
            return
        }
        loginManager.loginUser(email, password: password)
        print("Logging IN")
    }
    
    func loginSuccess() {
        print("About to segue")
        performSegueWithIdentifier("Login", sender: self)
        print("Segueing")
    }
    
    func loginFail() {
        print("is not logged in")
    }
    
    @IBAction private func logoutUserBarButton(button: UIBarButtonItem) {
        loginManager.logoutUser()
    }


    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.enabled = false
        loginButton.enabled = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loginSuccess), name: "LoggedInMsg", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loginFail), name: "LoggedInErrorMsg", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(regSuccess), name: "RegisteredMsg", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(regFail), name: "RegisterErrorMsg", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

