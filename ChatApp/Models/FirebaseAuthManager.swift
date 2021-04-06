//
//  FirebaseAuthManager.swift
//  ChatApp
//
//  Created by 최광현 on 2021/03/22.
//

import FirebaseAuth

class FirebaseAuthManager {
    
    var loginSuccess: Bool?
    
    public static let shared: FirebaseAuthManager = FirebaseAuthManager()
    
    private init () {}
    
    func login(_ id: String, _ pw: String, completionHandler: @escaping ((Bool) -> Void)){
        Auth.auth().signIn(withEmail: id, password: pw) { [weak self](result, error) in
            guard let strongSelf = self else {return}
            guard let authResult = result, error == nil  else {
                print("로그인 실패")
                self?.loginSuccess = false
                return
            }
            strongSelf.loginSuccess = true
            completionHandler(true)
        }
    }
    
    public func logout() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch (let error) {
            print("Logout Error occured : \(error.localizedDescription)")
        }
    }
}
