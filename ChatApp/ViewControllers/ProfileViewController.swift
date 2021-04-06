//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/22.
//

import UIKit
import SnapKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    let userInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        .navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(didTapLogout))
        view.addSubview(userInfoTableView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(didTapLogout))
    }
    
    private func setSubviewLayout() {
        userInfoTableView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    @objc
    private func didTapLogout() {
        print("tap logout")
        FirebaseAuthManager.shared.logout()
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
