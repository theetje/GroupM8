//
//  loginViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 11-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class loginViewController: UIViewController {
    
    // Instence of class for 
    let DatabaseQueryInstance = DatabaseQuerys()
    
    // Outlets
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var wachtwoordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // Actions:
    @IBAction func loginButton(_ sender: Any) {
        if mailTextField.text != "" && wachtwoordTextField.text != "" {
            Auth.auth().signIn(withEmail: mailTextField.text!, password: wachtwoordTextField.text!, completion: {(user, error) in
                if user != nil {
                    print("--- login gelukt! ---")
                    
                    self.DatabaseQueryInstance.findUserInfo(completion: { userInfo in
                        User.shared.chatName = userInfo.chatName
                        User.shared.email = userInfo.email
                        User.shared.group = userInfo.group
                        
                        self.performSegue(withIdentifier: "loginSucces", sender: self)
                    })
                } else {
                    if let myError = error?.localizedDescription {
                        // Geef de firebase error door aan een gebruiker en op terminal.
                        self.showAlert(title: "Login Error", message: myError)
                        print("Error description: \(myError)")
                    }
                }
            })
        } else {
            // Een veld is nog leeg.s
            showAlert(title: "Login Error", message: "A field is empty")
        }
        // Bounce effect
        loginButton.bounce()
    }
    
    // Overrides:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout:
        loginButton.layer.cornerRadius = 5
        self.hideKeyboardWhenTappedAround()
        // Haald de shadow onderaan de navigatie balk
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

