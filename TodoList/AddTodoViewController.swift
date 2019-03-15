//
//  AddTodoViewController.swift
//  TodoList
//
//  Created by pangthunyalak on 7/3/2562 BE.
//  Copyright © 2562 pangthunyalak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddTodoViewController: UIViewController {

    @IBOutlet weak var addItemTextField: UITextField!
    @IBOutlet weak var addItemButton: UIButton!
    private var dataBaseReference:DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItemButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Add item when out of condition
    @IBAction func addItemClicked(_ sender: Any) {
        let item = addItemTextField.text ?? ""
        if validateItem(item: item) {
            addItem(item: item)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Invalid Input", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Condition when typing in textfield
    @IBAction func textFieldEditngChanged(_ sender: UITextField) {
        if sender == self.addItemTextField {
            let text = addItemTextField.text ?? ""
            if text.count > 0 {
                addItemButton.isEnabled = true
            }else {
                addItemButton.isEnabled = false
            }
        }
    }

    //MARK: - Add item success
    
    private func addItem(item: String) {
        // database store data from textfield
        self.dataBaseReference = Database.database().reference()
        let todo = [ "title": item ,
                     "check": 0 ] as [String : Any]
        self.dataBaseReference.child("TodoList3").childByAutoId().setValue(todo)
        
    }
    
    private func validateItem(item: String) -> Bool {
        if item.count > 0 {
            return true
        }
        return false
    }
}


