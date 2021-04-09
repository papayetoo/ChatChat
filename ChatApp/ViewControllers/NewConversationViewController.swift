//
//  NewConversationViewController.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/22.
//

import UIKit
import SnapKit

class NewConversationViewController: UIViewController {

    let usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var users: [[String:String]]? {
        didSet {
            usersTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        view.addSubview(usersTableView)
        usersTableView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        
        DatabaseManager.shared.getUsers() {[weak self] result in
            switch result {
            case .success(let userData):
                print("Get usersData success")
                self?.users = userData
            case .failure(let err):
                print("DatabaseError \(err)")
            }
        }
    }
    
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        guard let userData = users?[indexPath.row] else {return cell}
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = userData["email"]
            cell.contentConfiguration = content
        } else {
            // Fallback on earlier versions
            cell.textLabel?.text = userData["email"]
        }
        
        return cell
    }
}
