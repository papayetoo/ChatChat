//
//  ViewController.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/22.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {
    
    lazy var loginIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.center = self.view.center
        
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    let testlabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "ConversationViewController"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackgroundColor()
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
        } else {
            print(FirebaseAuth.Auth.auth().currentUser?.email)
        }
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .systemBackground
        view.addSubview(testlabel)
        
        
        NSLayoutConstraint.activate([
            testlabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            testlabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
}
 
