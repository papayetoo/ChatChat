//
//  ViewController.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/22.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {
    
    let userTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.message"), style: .plain, target: self, action: #selector(didTapNewChat))
    }
    
    @objc
    private func didTapNewChat() {
        print("didTapNewChat")
        let newConversationVC = NewConversationViewController()
        newConversationVC.modalPresentationStyle = .fullScreen
        present(newConversationVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ConversationVC did appear")
        validateAuth()
        if isBeingDismissed {
            print("isBeingDismissed")
        }
        if isBeingPresented {
            print("conversationView isBeingDismissed")
        }
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            print("login 창으로 이동")
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
            return
        }
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else {
            return
        }
        StorageManager.shared.downloadProfileImage(with: email) { (result) in
            switch result {
            case .success(let profileImageData):
                print(profileImageData)
            case .failure(let error):
                print(error)
            }
        }
    }

}
 
