//
//  registerUserViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 15-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class registerUserViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets:
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var wachtwoordTextField: UITextField!
    @IBOutlet weak var wachtwoordTextFieldOpnieuw: UITextField!
    @IBOutlet weak var groupIDTextField: UITextField!
    @IBOutlet weak var chatNameTextField: UITextField!
    // Actions:
    @IBAction func registerUser(_ sender: Any) {
        // Kijk of de wachtwoord velden het zelfde zijn en niet leeg.
        if mailTextField.text != "" && wachtwoordTextField.text != "" {
            if wachtwoordTextField.text == wachtwoordTextFieldOpnieuw.text {
                if groupIDTextField.text != "" {
                    // Maak de acount aan.
                    Auth.auth().createUserAndRetrieveData(withEmail: mailTextField.text!, password: wachtwoordTextField.text!, completion: { (user, error) in
                        if user != nil {
                            // Maak de groep aan.
                            let databaseQueryInstence = DatabaseQuerys()
                            databaseQueryInstence.writeNewUserToDatabase(userGroup: self.groupIDTextField.text!, userMail: self.mailTextField.text!, chatName: self.chatNameTextField.text!)
                            
                            User.shared.chatName = self.chatNameTextField.text!
                            User.shared.email = self.mailTextField.text!
                            User.shared.group = self.groupIDTextField.text!
                            // Succes ga naar de pagina die gewenst is.
                            print("--- User account made ---")
                            self.performSegue(withIdentifier: "registeringComplete", sender: self)
                        } else {
                            // Geef een fout melding indien nodig.
                            if let myError = error?.localizedDescription {
                                print("--- Error description: \(myError) ---")
                            }
                        }
                    })
                } else {
                    print("group is empty")
                }
            } else {
                // Wachtwoorden is niet het zelfde.
                print("--- Password field are not the same ---")
            }

        } else {
            // Wachtwoord veld of text is leeg.
            print("--- Password field is empty ---")
        }
    }

    // Overrides:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Haald het toetsenbord weg als je ergens anders tapped.
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
