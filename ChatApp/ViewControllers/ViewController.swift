//
//  ViewController.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/22.
//

import UIKit

class ConversationViewController: UIViewController {
    
    let testlabel: UILabel = {
        let label = UILabel()
        label.text = "채팅 앱 기본 세팅"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackgroundColor()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .label
        view.addSubview(testlabel)
        NSLayoutConstraint.activate([
            testlabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            testlabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

}
 
