//
//  ReminderEditionViewController.swift
//  Reminders
//
//  Created by Kyrill Cousson on 28/01/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import UIKit
import CoreData

class ReminderEditionViewController: DataTableViewController, UITextFieldDelegate, LocationSelectionDelegate {
    
    enum Rows : String {
        case TitleRow = "Title"
        case DateRow = "Date"
        case DatePickerRow = "DatePicker"
        case LocationRow = "Location"
        case SaveRow = "Save"
    }
    
    enum Sections : String {
        case FormSection = "Form"
        case SaveSection = "Save"
    }
    
    struct Section {
        var sectionName:String
        var sectionRows:[Rows]
    }
    
    let FormSection = 0
    let ActionsSection = 1

    var isNewReminder = true
    var editionRows = [Rows]()
    let actionRows = [Rows.SaveRow]
    
    var sections = [Section]()
    
    let defaultDate = nearFutureDate()
    var reminder : Reminder?
    var entryIsValid = false
    
    // MARK: - Setup

    func setReminder(reminder:Reminder) {
        self.reminder = reminder
        entryIsValid = true
        isNewReminder = false
    }
    
    func setupNewReminder(){
        let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: self.moc())
        self.reminder = Reminder(entity: entity!, insertInto: self.moc())
        self.reminder!.id = UUID()
    }
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (self.reminder == nil){
            setupNewReminder()
        }
        
        editionRows = [Rows.TitleRow, Rows.DateRow]
        if (!isNewReminder && self.reminder?.dueDate != nil){
            editionRows.append(Rows.DatePickerRow)
        }
        editionRows.append(Rows.LocationRow)
        sections = [Section(sectionName: Sections.FormSection.rawValue, sectionRows: editionRows), Section(sectionName: Sections.SaveSection.rawValue, sectionRows: actionRows)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTextField()
    }
    
    // MARK: -
    
    func setupTextField(){
        let titleRowIndex = self.sections[FormSection].sectionRows.index(of:Rows.TitleRow)!
        let titleCell = self.tableView.cellForRow(at: IndexPath(row: titleRowIndex, section: FormSection))!
        let textField = titleCell.viewWithTag(2) as! UITextField
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueDidChange(textField:)), for: .editingChanged)
    }
    
    // MARK: - TableView Source & Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].sectionRows.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellId = self.sections[indexPath.section].sectionRows[indexPath.row]
        if (cellId == Rows.DatePickerRow){
            return 216
        }
        else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        let cellId = self.sections[indexPath.section].sectionRows[indexPath.row]
        
        switch cellId {
        case Rows.TitleRow:
            cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell")!
            let label = cell.viewWithTag(1) as! UILabel
            label.text = "Title:"
            
            let textField = cell.viewWithTag(2) as! UITextField
            textField.text = reminder?.title

        case Rows.DateRow:
            cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell")!
            let titleLabel = cell.viewWithTag(21) as! UILabel
            titleLabel.text = "Remind me on a date"
            
            let subtitleLabel = cell.viewWithTag(22) as! UILabel
            if let dueDate = reminder?.dueDate {
                subtitleLabel.text = (dueDate as Date).toFormattedString()
            }
            else {
                subtitleLabel.text = "-"
            }
        
            let dateSwitch = cell.viewWithTag(23) as! UISwitch
            dateSwitch.isOn = (reminder?.dueDate != nil)
            dateSwitch.addTarget(self, action: #selector(dateSwitchValueChanged(dateSwitch:)), for: .valueChanged)
            
        case Rows.LocationRow:
            cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell")!
            cell.textLabel?.text = "Remind me at a location"
            cell.accessoryType = .disclosureIndicator
            if let locationName = reminder?.location?.name {
                cell.detailTextLabel?.text = locationName
            }
            else {
                cell.detailTextLabel?.text = "-"
            }
        case Rows.DatePickerRow:
            cell = tableView.dequeueReusableCell(withIdentifier: "DateTimePickerCell")!
            let datePicker = cell.viewWithTag(11) as! UIDatePicker
            datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged)
            datePicker.minimumDate = defaultDate
            if let dueDate = reminder?.dueDate {
                datePicker.setDate(dueDate as Date, animated: false)
            }
        case Rows.SaveRow:
            cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
            cell.textLabel?.text = self.sections[indexPath.section].sectionRows[indexPath.row].rawValue
            cell.isUserInteractionEnabled = entryIsValid
            cell.textLabel?.textColor = entryIsValid ? UIColor.black : UIColor.gray
        }
        
        return cell
    }
    
    func reloadDateRow(){
        let dateIndex = self.sections[0].sectionRows.index(of:Rows.DateRow)!
        self.tableView.reloadRows(at: [IndexPath.init(row:dateIndex, section:0)], with: .none)
    }
    
    func reloadLocationRow(){
        let locationIndex = self.sections[FormSection].sectionRows.index(of:Rows.LocationRow)!
        self.tableView.reloadRows(at: [IndexPath.init(row:locationIndex, section:FormSection)], with: .fade)
    }
    
    
    // MARK: - Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldValueDidChange(textField: UITextField) {
        reminder?.title = textField.text!
        if (entryIsValid != !textField.text.isEmptyOrNil()){
            entryIsValid = !textField.text.isEmptyOrNil()
            self.tableView.reloadRows(at: [IndexPath.init(row:0, section:ActionsSection)], with: .none)
        }
    }
    
    @objc func dateSwitchValueChanged(dateSwitch: UISwitch){
        self.tableView.beginUpdates()

        if (dateSwitch.isOn){
            reminder?.dueDate = defaultDate as NSDate
            let dateSwitchIndex = self.sections[FormSection].sectionRows.index(of:Rows.DateRow)!
            let newRowIndex = dateSwitchIndex + 1
            self.sections[FormSection].sectionRows.insert(Rows.DatePickerRow, at: newRowIndex)
            self.tableView.insertRows(at: [IndexPath.init(row:newRowIndex, section:FormSection)], with: .fade)
        }
        else {
            reminder?.dueDate = nil
            if let datePickerIndex = self.sections[FormSection].sectionRows.index(of:Rows.DatePickerRow) {
                self.sections[FormSection].sectionRows.remove(at: datePickerIndex)
                self.tableView.deleteRows(at: [IndexPath.init(row:datePickerIndex, section:FormSection)], with: .fade)
            }
        }
        reloadDateRow()
        self.tableView.endUpdates()
    }
    
    @objc func datePickerChanged(datePicker: UIDatePicker){
        reminder?.dueDate = datePicker.date as NSDate
        reloadDateRow()
    }
    
    func didSelectLocation(_ location: Location) {
        reminder?.location = location
        reloadLocationRow()
    }
    
    // MARK: - User Actions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let cellId = self.sections[indexPath.section].sectionRows[indexPath.row]
        if (cellId == Rows.DateRow) {
            if let index = self.sections[indexPath.section].sectionRows.index(of:Rows.DatePickerRow){
                self.sections[indexPath.section].sectionRows.remove(at: index)
                self.tableView.deleteRows(at: [IndexPath.init(row:index, section:indexPath.section)], with: .automatic)
            }
            else {
                let newRowIndex = indexPath.row + 1
                self.sections[indexPath.section].sectionRows.insert(Rows.DatePickerRow, at: newRowIndex)
                self.tableView.insertRows(at: [IndexPath.init(row:newRowIndex, section:indexPath.section)], with: .automatic)
            }
        }
        else if (cellId == Rows.LocationRow) {
            let locationTVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationsTableViewController") as! LocationsTableViewController
            locationTVC.delegate = self
            self.navigationController?.pushViewController(locationTVC, animated: true)
        }
        else if (cellId == Rows.SaveRow) {
            DataHandler.saveData(onContext:self.moc())
            NotificationHandler.addNotificationFromReminder(reminder!)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelAct(_ sender: Any) {
        DataHandler.discardChanges(onContext: self.moc())
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK -
}
