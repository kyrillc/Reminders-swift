//
//  LocationsTableViewController.swift
//  Reminders
//
//  Created by Kyrill Cousson on 28/01/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import CoreData
import UIKit

protocol LocationSelectionDelegate {
    func didSelectLocation(_ location :Location)
}

class LocationsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private enum Sections: Int {
        case ActionSection = 0
        case LocationsSection = 1
    }
    
    private let NewLocationRow = "New location"
    private var actionSectionRows = [String]()
    var delegate : LocationSelectionDelegate!
    
    private var context: NSManagedObjectContext!
    
    private lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let locationsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        locationsFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: locationsFetchRequest,
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
        self.actionSectionRows = [NewLocationRow]
    }
    
    func presentLocationEditionView(with location: Location?) {
        let locationEditionVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationEditionViewController") as! LocationEditionViewController
        if let loc = location {
            locationEditionVC.setLocation(location: loc)
        }
        let navController = UINavigationController(rootViewController: locationEditionVC)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
            
            let location = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Location
            
            cell.textLabel?.text = location.titleString()
            cell.detailTextLabel?.text = location.remindersString()
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == Sections.ActionSection.rawValue, self.actionSectionRows[indexPath.row] == self.NewLocationRow {
            self.presentLocationEditionView(with: nil)
        }
        else {
            if (delegate != nil){
                let location = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Location
                delegate!.didSelectLocation(location)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == Sections.LocationsSection.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath.section == Sections.LocationsSection.rawValue) {
            var actions = [UITableViewRowAction]()
            let location = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Location
            if (location.reminders?.count == 0){
                actions.append(UITableViewRowAction.init(style: .destructive, title: "Delete", handler: editLocationAtIndexPath))
            }
            actions.append(UITableViewRowAction.init(style: .normal, title: "Edit", handler: editLocationAtIndexPath))
            return actions
        }
        return []
    }
    
    func editLocationAtIndexPath(action :UITableViewRowAction, indexPath :IndexPath){
        let location = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Location
        if (action.style == .destructive){
            DataHandler.deleteObject(location, onContext: self.context, andCommit: true)
        }
        else {
            self.presentLocationEditionView(with: location)
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
        return IndexPath(row: indexPath.row, section: Sections.LocationsSection.rawValue)
    }
    func fetchedResultControllerIndexPathFromTableViewIndexPath(_ indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row, section: 0)
    }
}
