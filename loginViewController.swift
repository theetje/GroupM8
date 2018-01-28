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
    
    // Actions:
    @IBAction func loginButton(_ sender: Any) {
        if mailTextField.text != "" && wachtwoordTextField.text != "" {
            Auth.auth().signIn(withEmail: mailTextField.text!, password: wachtwoordTextField.text!, completion: {(user, error) in
                if user != nil {
                    print("--- login gelukt! ---")
                    
                    let DatabaseQueryInstance = DatabaseQuerys()
                    DatabaseQueryInstance.findUserInfo(completion: { userInfo in
                        User.shared.chatName = userInfo.chatName
                        User.shared.email = userInfo.email
                        User.shared.group = userInfo.group
                        
                        self.performSegue(withIdentifier: "loginSucces", sender: self)
                    })
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
    
    // Overrides:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
