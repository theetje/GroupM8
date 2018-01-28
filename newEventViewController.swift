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
    let databaseQuerysInstance = DatabaseQuerys()
    var ref : DatabaseReference!
    var user: User?
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
            databaseQuerysInstance.writeEventToDatabase(userGroup: User.shared.group!, dateSetForEvent: formatter.string(from: strDate), eventName: eventTextField.text!, eventDescription: eventDesctiption.text!)
            // TODO: zorg dat na het oplaan evenementen wel ok blijven
            print("The date is saved.")
            dismiss(animated: true, completion: nil)
        } else {
            // TODO: Geef hier user warning.
            print("textField is leeg")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Verwijder toetsenbord bij tab
        self.hideKeyboardWhenTappedAround()
        
        datePickerOutlet.setValue(UIColor.white, forKey: "textColor")
        // datePickerOutlet.performSelector("setHighlightsToday:", withObject:DesignHelper.getOffWhiteColor())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
