//
//  agendaViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 16-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit
import JTAppleCalendar

class agendaViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // Outlets:
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calenderView: JTAppleCalendarView!
    @IBOutlet weak var yearLable: UILabel!
    @IBOutlet weak var monthLable: UILabel!
    
    // Date formatter object.
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    // Welke dag is het vandaag.
    let todaysDate = Date()
    
    // Gebruik een dict om evenementen in opteslaan van de server.
    var eventsFromTheServer: [String: String] = [:]
    
    // Overrides:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Haal data van de server naar een object.
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            // roep aan als object:
            let serverObject = self.getServerEvents()
            
            // Loop door de waarden heen en formateer
            for (date, event) in serverObject {
                let stringDate = self.formatter.string(from: date)
                self.eventsFromTheServer[stringDate] = event
            }
            
            // Omdate je geen langzame app wil async data ophalen.
            DispatchQueue.main.async {
                self.calenderView.reloadData()
            }
        }
        
        // setup van de cell waar 1 dag zich in bevind.
        setupCalandarView()
        
        // Scroll naar de huidige datum, zonder animatie
        calenderView.scrollToDate(Date(), animateScroll: false )
        
        calenderView.visibleDates { dateSegment in
            self.setupViewsOfCalendar(from: dateSegment)
        }
        
        // De functies voor het hamburger menu.
        hamburgerButton.target = self.revealViewController()
        hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
    }
    
    // Laat de evenementen zien die opgehaald worden van de server.
    func handleCellEvents(cell: calendarCollectionViewCell, cellState: CellState) {
        cell.dotSelecter.isHidden = !eventsFromTheServer.contains { $0.key == formatter.string(from: cellState.date) }
    }
    
    // Functie die de huidige datum laat zien.
    func handleTodaysDate(cell: calendarCollectionViewCell, cellState: CellState) {
        // Zorg voor zekerheid mbo de formatter.
        formatter.dateFormat = "yyyy MM dd"
        
        // Kijk naar de huidige data en pas de text aan.
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        if todaysDateString == monthDateString {
            cell.dateLable.textColor = UIColor.blue
        }
    }
    
    // Functie die de kleur veranderd bij selectie de selectie.
    func handleCellTextColor(cell: calendarCollectionViewCell, cellState: CellState) {
        if cellState.isSelected {
            cell.dateLable.textColor = UIColor.darkGray
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
    
    // Functions (nodig voor class):
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // collectionView hoord bij protocol
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // collectrionViewCell hoord bij protocol
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        return cell
    }
}

// Extensions van de ViewController:
extension agendaViewController: JTAppleCalendarViewDelegate {
    // Extentie voor de delegate
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        // Maak de cell de datum in staat.
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! calendarCollectionViewCell
        cell.dateLable.text = cellState.text
        
        // Functies die nodig zijn sbij creatie van de cell.
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        // Laat de geselecteerde cell zien
        // Functies die bij selectie gebruikt worden.
        configureCell(cell: cell, cellState: cellState)
        cell?.bounce()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        // functies die bij deselectie gebruikt worden.
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        // functie gaat over segment waar overheen gescroled wordt.
        setupViewsOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "header", for: indexPath) as! CalendarHeader
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
}

extension agendaViewController: JTAppleCalendarViewDataSource {
    // Extentie voor de DataSource
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        // Stel de start en eind datum van de calendar in.
        let startDate = formatter.date(from: "2010 01 01")
        let endDate = formatter.date(from: "2030 12 31")
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        
        return parameters
    }

    // Funcie hier onder moet om aan JTApplecalendarViewDataSource te voldoen.
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

    }
}

// Hieronder haalt de data uit de database
extension agendaViewController {
    func getServerEvents() -> [Date: String] {
        formatter.dateFormat = "yyyy MM dd"
        
        return [
            formatter.date(from: "2018 01 03")!: "Verjaardag",
            formatter.date(from: "2018 01 10")!: "Iets anders te doen",
            formatter.date(from: "2018 02 12")!: "Nog een evenement",
            formatter.date(from: "2018 03 03")!: "Zwembad feeste",
            formatter.date(from: "2018 03 20")!: "Geen feestje",
            formatter.date(from: "2018 02 01")!: "DDAY!!",
        ]
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
        }
        )
    }
}
