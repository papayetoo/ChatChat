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
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let uid = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        .navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(didTapLogout))
        view.addSubview(profileImageView)
        setSubviewLayout()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(didTapLogout))
        
        guard let uid = uid else {return}
        let path = "images/\(uid).png"
        DispatchQueue.global().async {
            StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let url):
                    strongSelf.downloadImage(imageView: strongSelf.profileImageView, url: url)
                case .failure(let error):
                    print("Failed to get download url: \(error)")
                }
            })
        }
//        DispatchQueue.global().async {
//            StorageManager.shared.downloadProfileImage(with: safetyEmail,
//                                                       completion: { [weak self] result in
//                                                        switch result{
//                                                        case .success(let data):
//                                                            DispatchQueue.main.async {
//                                                                print("프로필 이미지 다운로드 및 적용 중")
//                                                                self?.profileImageView.image = UIImage(data: data)
//                                                            }
//                                                        case .failure(let err):
//                                                            print("error occured \(err)")
//                                                        }
//                                                       })
//        }
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                guard let data = data , error == nil else {
                    return
                }

                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    imageView.image = image
                }
            }).resume()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    private func setSubviewLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.width.height.equalTo(100)
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
