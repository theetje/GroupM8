//
//  instellingenViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 25-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit
import FirebaseAuth
//import Firebase
//import FirebaseAuthUI

class instellingenViewController: UIViewController {
    
    let user = Auth.auth().currentUser
    
    // Outlets:
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var welkomeNameLabel: UILabel!
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var newGroupField: UITextField!
    @IBOutlet weak var changePasswordButtonOutlet: UIButton!
    @IBOutlet weak var changeGroupButtonOutles: UIButton!
    

    // Actions:
    @IBAction func changePassword(_ sender: Any) {
        // Creer credential object en kijk of het oude wachtwoord klopt.
        let credential = EmailAuthProvider.credential(withEmail: User.shared.email!, password: oldPasswordField.text!)

        user?.reauthenticate(with: credential) { error in
            if let error = error {
                print(error)
            } else {
                // User re-autenticated
                if self.newPasswordField?.text != "" {
                    Auth.auth().currentUser?.updatePassword(to: self.newPasswordField.text!, completion:{ (error) in
                        if let myError = error {
                            print(myError)
                            self.showAlert(title: "Oeps!", message: "\(myError)")
                        } else {
                            print("Wachtwoord is aangepast.")
                            self.showAlert(title: "Succes", message: "Password is changed.")
                        }
                    })
                } else {
                    print("New Password field can not be empty.")
                    self.showAlert(title: "Oeps!", message: "New Password field can not be empty.")
                }
            }
        }
        // Bounce effect
        changePasswordButtonOutlet.bounce()
    }
    
    @IBAction func changeGroup(_ sender: Any) {
        // Verander het User.shared object
        if newGroupField.text != "" {
            User.shared.group = newGroupField.text
            // Empty Field after usages.
            newGroupField.text = ""
        } else {
            print("No new group specified.")
            showAlert(title: "Oeps!", message: "No new groupt specified.")
        }
        
        // Bounce effect
        changeGroupButtonOutles.bounce()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout aanpassingen:
        welkomeNameLabel.text = "Welkom \(User.shared.chatName ?? "Gebruiker")"
        changeGroupButtonOutles.layer.cornerRadius = 5
        changePasswordButtonOutlet.layer.cornerRadius = 5
        self.hideKeyboardWhenTappedAround()
        
        // De functies voor het hamburger menu.
        hamburgerButton.target = self.revealViewController()
        hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
