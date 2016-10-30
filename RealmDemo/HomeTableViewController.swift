//
//  ViewController.swift
//  CoreData
//
//  Created by Kokpheng on 10/26/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import RealmSwift

class HomeTableViewController: UITableViewController, UISearchResultsUpdating {

    
    var lists : Results<Person>!
    
    var resultSearchController:UISearchController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        resultSearchController = UISearchController(searchResultsController: nil)
        // 2
        resultSearchController.searchResultsUpdater = self
        // 3
        resultSearchController.hidesNavigationBarDuringPresentation = true
        // 4
        resultSearchController.dimsBackgroundDuringPresentation = false
        // 5
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Default
        // 6
        resultSearchController.searchBar.sizeToFit()
        // 7
        tableView.tableHeaderView = resultSearchController.searchBar
        
        tableView.setContentOffset(CGPointMake(0, 44), animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
//        let personService = PersonService()
//        data = personService.getAll()
//        displayedData = data
//        tableView.reloadData()
        
        readTasksAndUpdateUI()
    }
    
    
    func readTasksAndUpdateUI(){
        let realm = try! Realm()
        lists = realm.objects(Person.self)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let data = lists{
            return data.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell")
        
        let person =  lists[indexPath.row]
        cell?.textLabel?.text = person.name
        cell?.detailTextLabel?.text = "Age: \(person.age)"
        cell?.imageView?.image = UIImage(data: person.profile)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            
            let personToBeDeleted = self.lists[indexPath.row]
            
            let realm = try! Realm()
            try! realm.write{
                
                realm.delete(personToBeDeleted)
                self.readTasksAndUpdateUI()
            }
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // Editing will go here
            let personToBeUpdated = self.lists[indexPath.row]
            self.performSegueWithIdentifier("showEdit", sender: personToBeUpdated)
            
        }
        return [deleteAction, editAction]
    }
    
    
    // MARK : Search Controller
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // Check if the user cancelled or deleted the search term so we can display the full list instead.
        let realm = try! Realm()
        
        if searchController.searchBar.text?.characters.count > 0 {
            // Query using an NSPredicate
            let searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", searchController.searchBar.text!)
            
            // filter data by predication
            self.lists = realm.objects(Person.self).filter(searchPredicate)
          
        }else{
             lists = realm.objects(Person.self)
        }
        tableView.reloadData()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEdit" {
            let destView = segue.destinationViewController as! AddEditTableViewController
            destView.person = sender as? Person
        }
        
    }

}

