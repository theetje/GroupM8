//
//  agendaViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 16-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit
import JTAppleCalendar

class agendaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // varbiabelen die nodig zijn.
    var user: User?
    var events = [Event]()
    var eventData = [Event]()
    
    // Outlets:
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var calenderView: JTAppleCalendarView!
    @IBOutlet weak var yearLable: UILabel!
    @IBOutlet weak var monthLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addNewDate(_ sender: Any) {
        performSegue(withIdentifier: "addNewDate", sender: self)
    }
    
    // Date formatter object.
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    // Overrides:
    override func viewDidLoad() {        
        super.viewDidLoad()

        // Layout:
        // Scroll naar de huidige datum, zonder animatie
        // setup van de cell waar 1 dag zich in bevind.
        setupCalandarView()
        // Ga naar vandaag.
        calenderView.scrollToDate(Date(), animateScroll: false )
        
        calenderView.visibleDates { dateSegment in
            self.setupViewsOfCalendar(from: dateSegment)
        }
        
        // Connect het nib (xib) bestand.
        let nib = UINib(nibName: "calendarTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "eventCell")
        
        // De functies voor het hamburger menu.
        hamburgerButton.target = self.revealViewController()
        hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Laat de tableView weten dat dit zijn bron van info is.
        tableView.dataSource = self
        tableView.delegate = self
        // Deze instelling maakt dat de calender per maand stopt.
        calenderView.scrollingMode = .stopAtEachSection
        
        // Zoek de data van de gebruiker op.
        DatabaseQuerys.shared.findUserInfo() { userInfo in
            self.user = userInfo
            // Haal de evenementen op uit de databse.
            DatabaseQuerys.shared.getCalendarEvents(userGroup: User.shared.group!, completion: { dataBaseData in
                
                self.events = dataBaseData
                
                // Reload data to show.
                self.calenderView.reloadData()
                self.tableView.reloadData()
            })
        }
    }
    
    // Functions:
    func setupCalandarView() {
        // setup van de cell waar 1 dag zich in bevind.
        calenderView.minimumLineSpacing = 0
        calenderView.minimumInteritemSpacing = 0
        
        // setup lables month and year
        calenderView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    // Configureer de stel met de functies die vervolgens gegeven zijn.
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = cell as? calendarCollectionViewCell else { return }
        
        handleCellSelected(cell: myCustomCell, cellstate: cellState)
        handleCellTextColor(cell: myCustomCell, cellState: cellState)
        handleTodaysDate(cell: myCustomCell, cellState: cellState)
        handleCellEvents(cell: myCustomCell, cellState: cellState)
        
        if cellState.dateBelongsTo == .thisMonth {
            cell?.isHidden = false
        } else {
            cell?.isHidden = true
        }
    }
    
    // Configureer event tableView.
    func configureTableView(cell: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = cell as? calendarCollectionViewCell else { return }
        
        let bool = events.contains { event in
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
            
            // Bij het toevoegen van een agenda event is eventDate nul vang hem dus op!
            guard let eventDate = formatter.date(from: event.date!) else { return false }
            formatter.dateFormat = "yyyy MM dd"
            return formatter.string(from: eventDate) == formatter.string(from: cellState.date)
        }
        
        if bool == true {
            eventData = handleSelectedDateEvents(cell: myCustomCell, cellState: cellState)
            tableView.reloadData()
        } else {
            eventData = [Event]()
        }
    }
    
    // Functie die info laat zien van de geselecteerde datum.
    func handleSelectedDateEvents(cell: calendarCollectionViewCell, cellState: CellState) -> [Event] {
        // Geef en zoek evens die op de datum plaats vinden.
        var eventsOnDate = [Event]()
        for event in events {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
            
            // Bij het toevoegen van een agenda event is eventDate nul vang hem dus op!
            guard let eventDate = formatter.date(from: event.date!) else { return eventsOnDate }
            
            formatter.dateFormat = "yyyy MM dd"
            
            if formatter.string(from: eventDate) == formatter.string(from: cellState.date) {
                eventsOnDate.append(event)
            }
        }
        return eventsOnDate
    }
    
    // Laat de evenementen zien die opgehaald worden van de server.
    func handleCellEvents(cell: calendarCollectionViewCell, cellState: CellState) {
        // Kijk of er events zijn geladen en of deze of de cellState.date plaatsvinden.
        cell.dotSelecter.isHidden = !events.contains { event in
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
            
            // Bij het toevoegen van een agenda event is eventDate nul vang hem dus op!
            guard let eventDate = formatter.date(from: event.date!) else { return false }
            
            formatter.dateFormat = "yyyy MM dd"
            return formatter.string(from: eventDate) == formatter.string(from: cellState.date)
        }
    }
    
    // Functie die de huidige datum laat zien.
    func handleTodaysDate(cell: calendarCollectionViewCell, cellState: CellState) {
        // Zorg voor zekerheid mbo de formatter.
        formatter.dateFormat = "yyyy MM dd"
        
        // Kijk naar de huidige data en pas de text aan.
        let todaysDateString = formatter.string(from: Date())
        let monthDateString = formatter.string(from: cellState.date)
        if todaysDateString == monthDateString {
            cell.dateLable.textColor = UIColor.white
        }
    }
    
    // Functie die de kleur veranderd bij selectie de selectie.
    func handleCellTextColor(cell: calendarCollectionViewCell, cellState: CellState) {
        if cellState.isSelected {
            cell.dateLable.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                cell.dateLable.textColor = UIColor.black
            } else {
                cell.dateLable.textColor = UIColor.gray
            }
        }
    }
    
    // Selecteerd en deselecteerd de cellen.
    func handleCellSelected(cell: calendarCollectionViewCell, cellstate: CellState) {
        if cell.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }

    // Maakt de datum en jaar labels.
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        yearLable.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        monthLable.text = formatter.string(from: date)
    }
                            /* --- Delegate functions nodig voor TableView --- */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Kijk hoeveel evenementen er zijn op een datum.
        return eventData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! calendarTableViewCell
        
        // Disable cell selection.
        cell.selectionStyle = .none
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        let formattedTime = formatter.date(from: eventData[indexPath.row].date!)
        formatter.dateFormat = "HH:mm"
        
        cell.eventTimeLabel?.text = formatter.string(from: formattedTime!)
        cell.eventNameLabel?.text = eventData[indexPath.row].eventName
        cell.eventDescriptionLabel.text = eventData[indexPath.row].eventDesctiption
        cell.dateID?.text = String(eventData[indexPath.row].eventKey!)
        
        // Laat zien hoeveel mensen zich hebben aangemeld voor een evenement.
        DatabaseQuerys.shared.getAttendeesEvent(userGroup: User.shared.group!, eventID: eventData[indexPath.row].eventKey!, completion: { attendees in
            cell.counterLabel.text = String(attendees)
        })
        
        return cell
    }
}
                            /* --- De functies hieronder zijn van de calendar package --- */
// Extensions van de ViewController:
extension agendaViewController: JTAppleCalendarViewDelegate {
    // Extentie voor de delegate
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        // Maak de cell de datum in staat.
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! calendarCollectionViewCell
        
        // Zet de juiste datum in de dateLabel
        cell.dateLable?.text = cellState.text
        
        // Functies die nodig zijn sbij creatie van de cell.
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    // Functies die bij selectie gebruikt worden.
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        // Laat de geselecteerde cell zien
        configureCell(cell: cell, cellState: cellState)
        
        // Haal Evenementen op van de geselecteerde dag.
        configureTableView(cell: cell, cellState: cellState)
        cell?.bounce()
    }
    
    // functies die bij deselectie gebruikt worden.
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    // functie gaat over segment waar overheen gescroled wordt.
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    // Header zijn de dagen van de week.
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "header", for: indexPath) as! CalendarHeader
        return header
    }
    
    // Is nodig voor het goed laten zien van de dagen van de week.
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
}

extension agendaViewController: JTAppleCalendarViewDataSource {
    // Extentie voor de DataSource
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        // Zet de dateFormater op de juiste datum.
        formatter.dateFormat = "yyyy MM dd"
        
        // Stel de start en eind datum van de calendar in.
        let startDate = formatter.date(from: "2010 01 01")
        let endDate = formatter.date(from: "2030 12 31")
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        
        return parameters
    }

    // Funcie hier onder moet om aan JTApplecalendarViewDataSource te voldoen.
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        // Maak de cell de datum in staat.
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! calendarCollectionViewCell
        cell.dateLable.text = cellState.text
        
        // Functies die nodig zijn sbij creatie van de cell.
        configureCell(cell: cell, cellState: cellState)
    }
}

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

