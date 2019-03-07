//
//  ShowToDoListTableViewController.swift
//  
//
//  Created by pangthunyalak on 6/3/2562 BE.
//

import UIKit

class ShowToDoListTableViewController: UITableViewController {
 
    
    
    var array:[String] = []
    
    var callAddItem: AddItemViewController = .init()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Show Item"
    }
    
    //show data in another page
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        callAddItem.getToDoList { (name) in
            self.array = name
            
        }

        return self.array.count
        
    }
//Any time you read Database data, you receive the data as a DataSnapshot.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowList", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    

    @IBAction func Add(_ sender: Any) {
        //reference to another page that set in main.storyboard
        var addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddItem") as! AddItemViewController
        self.navigationController?.pushViewController(addVC, animated: true)
        
    }
    
    
}
