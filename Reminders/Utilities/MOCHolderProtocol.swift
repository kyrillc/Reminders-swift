//
//  DataViewController.swift
//  Reminders
//
//  Created by Kyrill Cousson on 13/03/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

// The purpose of this file is to have a NSManagedObjectContext accessor that returns the same default value for classes having a NSManagedObjectContext

import UIKit
import CoreData

protocol MOCHolderProtocol {
    var context: NSManagedObjectContext! {get set}
}
extension MOCHolderProtocol {
    mutating func setupContext(context: NSManagedObjectContext) {
        self.context = context
    }
    func moc() -> NSManagedObjectContext {
        if (self.context == nil) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }
        return self.context
    }
}

class DataTableViewController : UITableViewController, MOCHolderProtocol {
    var context: NSManagedObjectContext!
}
class DataViewController : UIViewController, MOCHolderProtocol {
    var context: NSManagedObjectContext!
}
