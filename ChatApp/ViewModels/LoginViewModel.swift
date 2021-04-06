//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel {
    
    let idInputRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    let pwInputRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    let loginBtnEnableRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let loginBtnTouchedRelay: PublishRelay<Void> = PublishRelay()
    let loginResultSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()
    
    let authManager = FirebaseAuthManager.shared
    
    static let shared: LoginViewModel = LoginViewModel()
    
    private init() {
        idInputRelay
            .distinctUntilChanged()
            .bind(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        pwInputRelay
            .distinctUntilChanged()
            .bind(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        // 로그인 버튼 enable 결정하는 함수
        enableLoginButton()
        // 로그인 버튼 클릭시 FireBase Auth 이용한 로그인 실행
        touchLoginButton()
    }
    
    func enableLoginButton() {
        _ = Observable
            .combineLatest(idInputRelay.distinctUntilChanged(), pwInputRelay.distinctUntilChanged())
            .map {!$0.0.isEmpty && !$0.1.isEmpty}
            .bind(to: loginBtnEnableRelay)
            .disposed(by: disposeBag)
    }
    
    func touchLoginButton() {
        loginBtnTouchedRelay
            .subscribe(onNext: { [weak self] in
                print("LoginBtnTouchedRelay")
                guard let strongSelf = self else {return}
                let currentId = strongSelf.idInputRelay.value
                let currentPw = strongSelf.pwInputRelay.value
                strongSelf.authManager.login(currentId, currentPw) { (loginResult) in
                    strongSelf.loginResultSubject.onNext(loginResult)
                }
            })
            .disposed(by: disposeBag)
    }
}
