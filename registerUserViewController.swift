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
    
    // Outlets
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var wachtwoordTextField: UITextField!
    @IBOutlet weak var wachtwoordTextFieldOpnieuw: UITextField!
    @IBOutlet weak var groupIDTextField: UITextField!
    
    @IBAction func registerUser(_ sender: Any) {
        // Kijk of de wachtwoord velden het zelfde zijn en niet leeg.
        if mailTextField.text != "" && wachtwoordTextField.text != "" {
            if groupIDTextField.text != "" {
                print("Group is not empty")
            } else {
                print("group is empty")
            }
            if wachtwoordTextField.text == wachtwoordTextFieldOpnieuw.text {
                Auth.auth().createUserAndRetrieveData(withEmail: mailTextField.text!, password: wachtwoordTextField.text!, completion: { (user, error) in
                    if user != nil {
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
                // Wachtwoorden is niet het zelfde.
                print("--- Password field are not the same ---")
            }

        } else {
            // Wachtwoord veld of text is leeg.
            print("--- Password field is empty ---")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
