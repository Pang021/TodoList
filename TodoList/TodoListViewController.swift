//
//  TodoListViewController.swift
//  TodoList
//
//  Created by pangthunyalak on 7/3/2562 BE.
//  Copyright © 2562 pangthunyalak. All rights reserved.
//

import UIKit
import FirebaseDatabase
import NVActivityIndicatorView

class TodoListViewController: UIViewController {

    // MARK: IBOUTLET Properties
    @IBOutlet weak var tableView: UITableView!
    
    private var databaseReference: DatabaseReference!
    
    static let segueIdentifier = "todoListGoToAddItem"
    static let cellIdentifier = "TodoListCell"
    
    var todoListDataSource = [DataSnapshot]()
    var checked = Set<IndexPath>()
    
    // MARK: View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTodoListDataSource()
        fetchDataFromDatabase { [weak self] (todoItems) in
            self?.todoListDataSource.append(contentsOf: todoItems)
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func clearTodoListDataSource() {
        self.todoListDataSource.removeAll()
    }
    
    private func fetchDataFromDatabase(completion: @escaping (_ data: [DataSnapshot])-> Void) {
        
        self.databaseReference = Database.database().reference()
        self.indicatorView(isLoad: true)
        
        
        var tempTodo = [DataSnapshot]()

        self.databaseReference.child("TodoList2").observeSingleEvent(of: .value) { (dataSnapshot) in
            for child in dataSnapshot.children {
                if let item = child as? DataSnapshot {
                    tempTodo.append(item)
                }
                self.indicatorView(isLoad: false)
            }
            completion(tempTodo)
        }
        
    }
    
    @IBAction func AddItemClicked(_ sender: Any) {
        self.performSegue(withIdentifier: TodoListViewController.segueIdentifier, sender: nil)
    }
    //MARK: - UITableViewDelegate
    
    func selectItem(_ indexPath: IndexPath) {
        if checked.contains(indexPath) {
            checked.remove(indexPath)
        }else{
            checked.insert(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}

//MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListViewController.cellIdentifier, for: indexPath) as! CustomTableViewCell
        let todo = todoListDataSource[indexPath.row]

        cell.messageTextLable1.text = String(describing: todo.value!)

        if checked.contains(indexPath) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            let todo = self.todoListDataSource[indexPath.row]
            todo.ref.removeValue(completionBlock: { (_, _) in
                self.todoListDataSource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            })
        }
        
        action.image = UIImage(named: "trush")
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItem(indexPath)
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
//        // 2
//
//        let checkItem = todoListDataSource[indexPath.row]
//
//         //3
//        let toggledCompletion = !checkItem.complete
//        // 4
//        checkItem(cell, isCompleted: toggledCompletion)
//        // 5
//        checkItem.ref?.updateChildValues([
//            "completed": toggledCompletion
//            ])
//
//    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Check") { (action, view, completion) in
            self.selectItem(indexPath)
            completion(true)
        }
        action.image = UIImage(named: "check")
        action.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [action])
    }


}




extension TodoListViewController : NVActivityIndicatorViewable{
    
    //MARK: - Indicator load
    func indicatorView(isLoad: Bool)
    {
        switch isLoad {
        case true:
            startAnimating(type: .ballRotateChase)
        default:
            stopAnimating()
        }
    }
}

