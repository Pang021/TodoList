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
    @IBOutlet weak var searchBar: UISearchBar!
    
    private lazy var databaseReference = Database.database().reference()
    
    static let segueIdentifier = "todoListGoToAddItem"
    static let cellIdentifier = "TodoListCell"
    
    var todoListDataSource = [DataSnapshot]()
    var filtered: [DataSnapshot] = []
    var searchActive = false
//    var checked = Set<IndexPath>()
    
    // MARK: View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observeEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTodoListDataSource()
//        fetchDataFromDatabase { [weak self] (todoItems) in
//            self?.todoListDataSource.append(contentsOf: todoItems)
//            self?.tableView.reloadData()
//        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    private func clearTodoListDataSource() {
        self.todoListDataSource.removeAll()
    }
    
    private func fetchDataFromDatabase(completion: @escaping (_ data: [DataSnapshot])-> Void) {
        
        self.indicatorView(isLoad: true)
        
        var tempTodo = [DataSnapshot]()

        self.databaseReference.child("TodoList3").observeSingleEvent(of: .value) { (dataSnapshot) in
            for child in dataSnapshot.children {
                if let item = child as? DataSnapshot {
                    tempTodo.append(item)
                }
                self.indicatorView(isLoad: false)
            }
            completion(tempTodo)
        }
        
    }
    
    func observeEvent() {
        self.indicatorView(isLoad: true)
        databaseReference.child("TodoList3").observe(.value) { (snapShot) in
            var data: [DataSnapshot] = []
            for child in snapShot.children {
                if let item = child as? DataSnapshot {
                    data.append(item)
                }
                self.indicatorView(isLoad: false)
            }
            self.todoListDataSource = data
            self.tableView.reloadData()
            
        }
        
    }
    
    @IBAction func AddItemClicked(_ sender: Any) {
        self.performSegue(withIdentifier: TodoListViewController.segueIdentifier, sender: nil)
    }
    
    //MARK: - UITableViewDelegate
    
    func selectItem(_ indexPath: IndexPath) {
        let todo = self.todoListDataSource[indexPath.row]
        var todoItem = todo.value as! [String: Any]
        
        if todoItem["check"] as! Int == 1 {
            todoItem["check"] = 0
        } else {
           todoItem["check"] = 1
        }
        
        
        
        self.databaseReference.child("TodoList3").child(todo.key).setValue(todoItem)
        
//        if checked.contains(indexPath) {
//            checked.remove(indexPath)
//        }else{
//            checked.insert(indexPath)
//        }
       
        //tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
}

//MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filtered.count : todoListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListViewController.cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        let todo = searchActive ? filtered[indexPath.row] : todoListDataSource[indexPath.row]
        let todoItem = todo.value as! [String: Any]
        
        cell.messageTextLable1.text = String(describing: todoItem["title"]! )
      
//        })

        if todoItem["check"] as! Int == 1 {
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

//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let action = UIContextualAction(style: .normal, title: "Check") { (action, view, completion) in
//            self.selectItem(indexPath)
//            completion(true)
//        }
//        action.image = UIImage(named: "check")
//        action.backgroundColor = .green
//        return UISwipeActionsConfiguration(actions: [action])
//    }
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

//MARK: - Search Function
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchActive = !searchText.isEmpty

        filtered = todoListDataSource.filter({ snapShot -> Bool in
            
            let todoItem = snapShot.value as! [String: Any]
            let text = todoItem["title"] as! NSString
            
            let range: NSRange = text.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
       
        tableView.reloadData()
        
    }
    
}




