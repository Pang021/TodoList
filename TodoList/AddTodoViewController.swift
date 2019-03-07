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
    
    
    private func addItem(item: String) {
        // database store data from textfield
        self.dataBaseReference = Database.database().reference()
        self.dataBaseReference.child("TodoList2").childByAutoId().setValue(item)
    }
    
    private func validateItem(item: String) -> Bool {
        if item.count > 0 {
            return true
        }
        return false
    }
}


