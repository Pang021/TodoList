//
//  AddItemViewController.swift
//  TodoList
//
//  Created by pangthunyalak on 6/3/2562 BE.
//  Copyright © 2562 pangthunyalak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddItemViewController: UIViewController {

    
    var dataReload: (()-> Void )?
    var dataBaseRefer:DatabaseReference!
    
    //call data from another page (call back function)
    func getToDoList(oNSuccess dataArray:@escaping (_ data:[String])->Void){
        
        self.dataBaseRefer = Database.database().reference()
        self.dataBaseRefer.child("TodoList2").observeSingleEvent(of: .value) { (dataSnap) in
            var Todo:[String]=[]
            
            for child in dataSnap.children{
                let snap = child as! DataSnapshot
                let value = snap.value
                Todo.append("\((value ?? ""))")
            }
            dataArray(Todo)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Item"

        // Do any additional setup after loading the view.
        
    }
    
    
    @IBOutlet weak var TypingItem: UITextField!

    
    
    @IBAction func AddItem(_ sender: Any) {
        
        // database store data from textfiele
        let data = TypingItem.text
        self.dataBaseRefer = Database.database().reference()
        self.dataBaseRefer.child("TodoList2").childByAutoId().setValue(data)
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
