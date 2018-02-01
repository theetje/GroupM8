//
//  newEventViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 19-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit
import FirebaseDatabase

class newEventViewController: UIViewController {
    // ref wordt een DatabaseReference object
    var ref : DatabaseReference!
    var strDate = Date()
    
    // Date formatter object.
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        return dateFormatter
    }()

    // Outlets:
    // Voor de datepicker is een Outlet en een action nodig, action meet verandering
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var eventDesctiption: UITextField!
    
    // Actions:
    @IBAction func cancelNewEvent(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePicker(_ sender: Any) {
        // Verander datum als dit moet
        strDate = datePickerOutlet.date
    }
    
    @IBAction func saveTheDate(_ sender: Any) {
        if eventTextField.text != "" {
            DatabaseQuerys.shared.writeEventToDatabase(userGroup: User.shared.group!, dateSetForEvent: formatter.string(from: strDate), eventName: eventTextField.text!, eventDescription: eventDesctiption.text!)
            
            print("The date is saved.")
            dismiss(animated: true, completion: nil)
        } else {
            // Geef hier user warning.
            print("textField is leeg")
            showAlert(title: "Oeps!", message: "No eventname pressent.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Maak de loop v/d return key:
        eventTextField.addTarget(eventDesctiption, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        
        // Layout:
        self.hideKeyboardWhenTappedAround()
        addKeyboardNotifications()
        
        datePickerOutlet.setValue(UIColor.white, forKey: "textColor")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
