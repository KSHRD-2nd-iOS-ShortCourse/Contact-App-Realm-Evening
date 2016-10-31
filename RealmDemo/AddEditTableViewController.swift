//
//  AddEditTableViewController.swift
//  CoreDataDemo
//
//  Created by Kokpheng on 10/26/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import RealmSwift

class AddEditTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var person : Person?
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var ageTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate for imagePicker
        imagePicker.delegate = self
        
        if person != nil {
            self.nameTextField.text = person?.name
            self.ageTextField.text = "\(person!.age)"
            self.profileImageView.image = UIImage(data: (person?.profile)!)
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
   
    @IBAction func brosweImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        // show image picker
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profileImageView.contentMode = .ScaleAspectFit
            profileImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveData(sender: AnyObject) {
        // Create an instance of the service.
        
        var age = 18
        
        if let personAge = Int(ageTextField.text!) {
            age =  personAge
        }
        
        let realm = try! Realm()
        if self.person != nil{
            // update mode
            
            try! realm.write {
                self.person!.name = nameTextField.text!
                self.person!.age = age
                self.person!.profile = UIImagePNGRepresentation(profileImageView.image!)!
                realm.add(self.person!, update: true) //use this if have id
            }
        }
        else{
            let person = Person(value: ["name" : nameTextField.text! as AnyObject, "age" : Int(ageTextField.text!) as! AnyObject, "profile" :UIImagePNGRepresentation(profileImageView.image!) as! AnyObject])
            
            try! realm.write {
                realm.add(person)
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true) // After save go back to home.
    }
}
