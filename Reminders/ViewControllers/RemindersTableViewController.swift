//
//  ReminderTableViewController.swift
//  Reminders
//
//  Created by Kyrill Cousson on 28/01/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import CoreData
import UIKit

class RemindersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    enum Sections: Int {
        case ActionSection = 0
        case RemindersSection = 1
    }

    let NewReminderRow = "New reminder"
    var actionSectionRows = [String]()

    var context: NSManagedObjectContext!

    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let remindersFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminder")
        let primarySortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        remindersFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]

        let frc = NSFetchedResultsController(
            fetchRequest: remindersFetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil)

        frc.delegate = self

        return frc
    }()

    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("error at fetchedResultsController.performFetch()")
        }
    }
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.fetchData()
        self.actionSectionRows = [NewReminderRow]
    }
    
    func presentReminderEditionView(with reminder: Reminder?) {
        let reminderEditionVC = self.storyboard?.instantiateViewController(withIdentifier: "ReminderEditionViewController") as! ReminderEditionViewController
        if let rem = reminder {
            reminderEditionVC.setReminder(reminder: rem)
        }
        let navController = UINavigationController(rootViewController: reminderEditionVC)
        self.present(navController, animated: true, completion: nil)
    }

    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.ActionSection.rawValue {
            return self.actionSectionRows.count
        } else {
            if let sectionobjects = self.fetchedResultsController.sections?[0].objects {
                return sectionobjects.count
            }
            return 0
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.ActionSection.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell")!
            cell.textLabel?.text = actionSectionRows[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell")!

            let reminder = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Reminder

            cell.textLabel?.text = reminder.title

            var subtitle = ""
            if let dueDate = reminder.dueDate {
                subtitle += (dueDate as Date).toFormattedString()
            }
            if let location = reminder.location {
                subtitle += subtitle.isEmpty ? location.name! : " - " + location.name!
            }
            cell.detailTextLabel?.text = subtitle

            if reminder.done {
                cell.accessoryType = .checkmark
                cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 12)
            } else {
                cell.accessoryType = .none
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            }

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Sections.ActionSection.rawValue, self.actionSectionRows[indexPath.row] == self.NewReminderRow {
            self.presentReminderEditionView(with: nil)
        } else {
            let reminder = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Reminder
            reminder.done = !reminder.done
            DataHandler.saveData(onContext:self.context)
            if (reminder.done){
                NotificationHandler.removeReminderNotification(reminder: reminder)
            }
            else {
                NotificationHandler.addNotificationFromReminder(reminder)
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == Sections.RemindersSection.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath.section == Sections.RemindersSection.rawValue) {
            return [UITableViewRowAction.init(style: .destructive, title: "Delete", handler: editReminderAtIndexPath),
                    UITableViewRowAction.init(style: .normal, title: "Edit", handler: editReminderAtIndexPath)]
        }
        return []
    }
    
    func editReminderAtIndexPath(action :UITableViewRowAction, indexPath :IndexPath){
        let reminder = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Reminder
        if (action.style == .destructive){
            NotificationHandler.removeReminderNotification(reminder: reminder)
            DataHandler.deleteObject(reminder, onContext: self.context, andCommit: true)
        }
        else {
            self.presentReminderEditionView(with: reminder)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let deletedIndexPath = indexPath {
                self.tableView.deleteRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(deletedIndexPath)], with: .automatic)
            }
        case .insert:
            if let insertedIndexPath = newIndexPath {
                self.tableView.insertRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(insertedIndexPath)], with: .automatic)
            } case .move:
            if let deletedIndexPath = indexPath {
                self.tableView.deleteRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(deletedIndexPath)], with: .automatic)
            }
            if let insertedIndexPath = newIndexPath {
                self.tableView.insertRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(insertedIndexPath)], with: .automatic)
            }
        case .update:
            if let updatedIndexPath = indexPath {
                self.tableView.reloadRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(updatedIndexPath)], with: .automatic)
            }
        default:
            return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    func tableViewIndexPathFromFetchedResultControllerIndexPath(_ indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row, section: Sections.RemindersSection.rawValue)
    }
    func fetchedResultControllerIndexPathFromTableViewIndexPath(_ indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row, section: 0)
    }
}
