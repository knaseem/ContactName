//
//  ViewController.swift
//  ContactName
//
//  Created by Khalid Naseem on 27/07/2016.
//  Copyright © 2016 Khalid Naseem. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    var contacts = [NSManagedObject]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "\"Contact Names\""
        tableView.registerClass(UITableViewCell.self,
                                forCellReuseIdentifier: "Cell")
    }
    
    func saveName(name: String) {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Employee",
                                                        inManagedObjectContext:managedContext)
        
        let employee = NSManagedObject(entity: entity!,
                                       insertIntoManagedObjectContext: managedContext)
        
        //3
        employee.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext.save()
            //5
            contacts.append(employee)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }


    @IBAction func addName(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Contact Name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveName(textField!.text!)
                                        self.tableView.reloadData()
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Employee")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            contacts = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let employee = contacts[indexPath.row]
        
        cell!.textLabel!.text =
            employee.valueForKey("name") as? String
        
        
        return cell!
    }

}

