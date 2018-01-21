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
    var strDate: String?
    var user: User?
    
    // Outlets:
    // Voor de datepicker is een Outlet en een action nodig, action meet verandering
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var eventTextField: UITextField!
    
    // Actions:
    @IBAction func datePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        dateFormatter.dateFormat = "yyyy MM dd HH:mm:ss"
        
        strDate = dateFormatter.string(from: datePickerOutlet.date)
    }
    
    @IBAction func saveTheDate(_ sender: Any) {
        if eventTextField.text != "" {
            databaseQuerysInstance.writeEventToDatabase(userGroup: (user?.group)!, dateSetForEvent: strDate!, eventName: eventTextField.text!)
            // TODO: Geef aan dat de datum is opgeslagen... Segue ofzo.
            print("The date is saved.")
        } else {
            // TODO: Geef hier userwarning.
            print("textField is leeg")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Zoek de data van de gebruiker op.
        databaseQuerysInstance.findUserInfo() { userInfo in
            self.user = userInfo
        }
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
