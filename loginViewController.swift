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
    // Outlets
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var wachtwoordTextField: UITextField!
    @IBOutlet weak var groupIDTextField: UITextField!
    
    // Actions:
    @IBAction func loginButton(_ sender: Any) {
        if mailTextField.text != "" && wachtwoordTextField.text != "" {
            Auth.auth().signIn(withEmail: mailTextField.text!, password: wachtwoordTextField.text!, completion: {(user, error) in
                if user != nil {
                    print("--- login gelukt! ---")
                    self.performSegue(withIdentifier: "loginSucces", sender: self)
                } else {
                    if let myError = error?.localizedDescription {
                        print("Error description: \(myError)")
                    }
                }
            })
        } else {
            print("Een veld is leeg")
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
