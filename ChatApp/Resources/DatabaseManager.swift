//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by 최광현 on 2021/04/05.
//

import Foundation
import FirebaseDatabase

// Final means there are no subclass
final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init () {}
    
    private let database = Database.database().reference()
}

// MARK: -Account Management

extension DatabaseManager {
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// Insert new user to database
//    public func insertUser(_ uid: with user: ChatAppUser) {
//        database.child(user.emailAddress).setValue([
//            "name": user.name
//        ])
//    }
    
    public func insertUser(with uid: String, user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(uid).setValue([
            "email": user.emailAddress,
            "name": user.name,
//            "imageUrl": user.profileImageUrl
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            completion(true)
        })
    }
}


struct ChatAppUser {
    let name: String
    let emailAddress: String
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    var profileImageFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
