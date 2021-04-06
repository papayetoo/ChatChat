//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/22.
//

import UIKit
import RxSwift
import SnapKit
import FirebaseStorage
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.image = UIImage(systemName: "person.circle")
        imageView.largeContentImageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    // loginViewModel 싱글톤 패턴 사용
    fileprivate let viewModel = LoginViewModel.shared
    private var disposeBag = DisposeBag()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이름"
        label.textColor = .label
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "이름"
        textField.textColor = .label
        return textField
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ID"
        label.textColor = .label
        return label
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ID"
        textField.textContentType = .emailAddress
        textField.textColor = .label
        return textField
    }()
    
    let pwLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password"
        label.textColor = .label
        return label
    }()
    
    let pwTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textColor = .label
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.secondaryLabel, for: .disabled)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        addSubviews()
        
        bindUI()
        setImageViewTouch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            print("RegisterVC isBeingDismissed")
            FirebaseAuthManager.shared.logout()
        }
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.width / 2.0
    }
    
    
    // MARK: subViews를 rootView에 추가
    func addSubviews() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(pwLabel)
        view.addSubview(pwTextField)
        view.addSubview(signUpButton)
        view.addSubview(signUpButton)
        view.addSubview(profileImageView)
    }
    
    func setImageViewTouch() {
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didTapChangeProfileImage() {
        presentPhotoActionSheet()
    }
    
    func layoutSubviews() {
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(100)
            $0.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        nameTextField.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(20)
            $0.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        idLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        idTextField.snp.makeConstraints {
            $0.leading.equalTo(idLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(idLabel.snp.centerY)
        }
        
        pwLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
        }
        
        pwTextField.snp.makeConstraints {
            $0.leading.equalTo(pwLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(pwLabel.snp.centerY)
        }
        
        signUpButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(pwTextField.snp.bottom).offset(20)
        }
        
    }
    
    func bindUI() {
        signUpButton.addTarget(self, action: #selector(tapSignUpButton), for: .touchUpInside)
    }
    
    @objc
    private func tapSignUpButton() {
        guard let profileImage = profileImageView.image, let name = nameTextField.text, var email = idTextField.text, let password = pwTextField.text, !name.isEmpty, !email.isEmpty, !password.isEmpty else {return}
        DispatchQueue.global().async { [weak self] in
            print("tap sign up button")
            print("email: \(email), password = \(password)")
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] authResult, error in
                guard let strongSelf = self else {return}
                guard authResult != nil, let uid = authResult?.user.uid else {
                    print("Error Creating user: \(email)")
                    return
                }
    //            let chatUser = ChatAppUser(name: name, emailAddress: email)
    //            DatabaseManager
    //                .shared
    //                .insertUser(with: uid,
    //                            user: chatUser,
    //                            completion: { success in
    //                                if success {
    //                                    // upload Profile Image
    //                                    guard let data = profileImage.pngData() else
    //                                    {return}
    //                                    let fileName = chatUser.profileImageFileName
    //                                    StorageManager.shared.uploadProfileImage(with: data, fileName: fileName, completion: { result in
    //                                        switch result {
    //                                        case .success(let downloadUrl):
    //                                            UserDefaults.standard.setValue(downloadUrl, forKey: "profile_picture_url")
    //                                            print(downloadUrl)
    //                                        case .failure(let error):
    //                                            print("storage manager error: \(error)")
    //                                        }
    //                                    })
    //                                }
    //                            })
                print("업로드 완료")
                DispatchQueue.main.async {
                    strongSelf.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}

extension RegisterViewController: UITextFieldDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == idTextField {
            pwTextField.becomeFirstResponder()
        } else if textField == pwTextField {
            self.viewModel.loginBtnTouchedRelay.accept(())
            let conversationViewController = ConversationViewController()
            self.present(conversationViewController, animated: true, completion: nil)
        }
        
        return true
    }
}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Pictrue", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentCamera()
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
                                            }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.profileImageView.image = selectedImage
    }
}
