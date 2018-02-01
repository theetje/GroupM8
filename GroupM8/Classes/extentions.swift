//
//  extentions.swift
//  GroupM8
//
//  Created by Thomas De lange on 30-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import Foundation

extension UIViewController {
    // User alert fuctie om gebruikers te vertellen wat ze niet goed doen.
    func showAlert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Functie die Keyboard effectief weghaald.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Vervolg functie die in ViewDidLoad gebruikt wordt.
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // Aditionele fuctie die de view regelt als het toetsenbord omhoog komt (gaat de view mee)
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    // Aditionele fuctie die de view regelt als het toetsenbord omlaag gaat (gaat de view mee)
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

// Extentie voor het bounce effectje
extension UIView {
    func bounce() {
        // Animatie van de cell
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 0.5,
            delay: 0, usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.1,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}
