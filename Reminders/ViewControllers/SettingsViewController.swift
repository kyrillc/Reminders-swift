//
//  SettingsViewController.swift
//  Reminders
//
//  Created by Kyrill Cousson on 04/03/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import Foundation
import UIKit


class SettingsViewController: UITableViewController {
    
    private let SavedLocationsRow = "Saved locations"
    private var rows = [String]()
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.rows = [SavedLocationsRow]
    }
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        cell.textLabel?.text = self.rows[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if self.rows[indexPath.row] == self.SavedLocationsRow {
            let locationTVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationsTableViewController") as! LocationsTableViewController
            self.navigationController?.pushViewController(locationTVC, animated: true)
        }
    }
    
}
