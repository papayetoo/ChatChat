//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/22.
//

import UIKit
import RxSwift
import SnapKit

class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    // loginViewModel 싱글톤 패턴 사용
    private let viewModel = LoginViewModel.shared
    private var disposeBag = DisposeBag()
    
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
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.secondaryLabel , for: .disabled)
        return button
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        addSubviews()
        layoutSubviews()
        bindUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc
    private func didTapRegister() {
        print("tap register")
        let registerVC = RegisterViewController()
        registerVC.title = "회원가입"
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /// Add subviews
    func addSubviews() {
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(pwLabel)
        view.addSubview(pwTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        signUpButton.addTarget(self,
                               action: #selector(didTapRegister),
                               for: .touchUpInside)
    }
    
    func layoutSubviews() {
        idLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX).offset(-30 + (idLabel.text?.count ?? 0))
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-20)
        }
        
        idTextField.snp.makeConstraints {
            $0.leading.equalTo(idLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-20)
            $0.width.equalTo(150)
            $0.height.equalTo(50)
        }
        
        pwLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX).offset(-30 + (pwLabel.text?.count ?? 0))
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(20)
        }
        
        pwTextField.snp.makeConstraints {
            $0.leading.equalTo(pwLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(20)
            $0.width.equalTo(150)
            $0.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide).offset(-35)
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        signUpButton.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide).offset(35)
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
    }
    
    func bindUI() {
        idTextField
            .rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.idInputRelay)
            .disposed(by: disposeBag)
        
        pwTextField
            .rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.pwInputRelay)
            .disposed(by: disposeBag)
        
        viewModel.loginBtnEnableRelay
            .subscribe(onNext: {[weak self] in
                self?.loginButton.isEnabled = $0
            })
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                // Dismiss the keyboard
                self?.idTextField.resignFirstResponder()
                self?.pwTextField.resignFirstResponder()
                
                self?.viewModel.loginBtnTouchedRelay.accept(())
                self?.viewModel
                    .loginResultSubject
                    .bind(onNext: {[weak self] result in
                        print("로그인 결과 : \(result)")
                        if result {
                            print("로그인 성공")
                            self?.dismiss(animated: true, completion: nil)
                        }
                    })
            })
            .disposed(by: disposeBag)
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

extension LoginViewController: UITextFieldDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
