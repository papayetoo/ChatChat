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
    
    
    public func insertUser(with uid: String, user: ChatUser, completion: @escaping (Bool) -> Void) {
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
            
            self.database.child("users")
                .observeSingleEvent(of: .value, with: { snapshot in
                    if var usersCollection = snapshot.value as? [[String: String]] {
                        // append to user dictionary
                        usersCollection.append([
                            "name": user.name,
                            "email": user.emailAddress
                            ])
                        self.database.child("users").setValue(usersCollection, withCompletionBlock: {  error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    }
                    else {
                        let newCollection: [[String:String]] = [
                            [
                            "name": user.name,
                            "email": user.emailAddress
                            ]
                        ]
                        self.database.child("users").setValue(newCollection, withCompletionBlock: {  error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    }
            })
//            completion(true)
        })
    }
    
    public func getUsers(completion: @escaping (Result<[[String:String]], Error>) -> Void) {
        database.child("users").observe(.value, with: { snapshot in
            guard let userData = snapshot.value as? [[String:String]] else {
                completion(.failure(DatabaseError.SnapshotValueError))
                return
            }
            completion(.success(userData))
        })
    }
}

enum DatabaseError: Error {
    case SnapshotValueError
}
