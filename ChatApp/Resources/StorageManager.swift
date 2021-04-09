//
//  StorageManager.swift
//  ChatApp
//
//  Created by 최광현 on 2021/04/06.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    /*
     /images/papayetoo-gmail-com_profile_image.png
     */
    public typealias UploadImageCompletion = (Result<String, Error>) -> Void
    public typealias DownloadImageCompletion = (Result<Data, Error>) -> Void
    /// Upload picture to firebase storage and returns completion with url string to download
    public func uploadProfileImage(with data: Data,
                                   fileName: String,
                                   completion: @escaping UploadImageCompletion)
    {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {
             metaData, error in
            guard error == nil else {
                // failed
                print(error?.localizedDescription)
                print("failed to upload data to firebase for profile image")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage
                .child("images/\(fileName)")
                .downloadURL(completion: {url, error in
                    guard let url = url else {
                        print("failed to upload data to firebase for profile image")
                        completion(.failure(StorageErrors.failedToGetDownloadUrl))
                        return
                    }
                    
                    let urlString = url.absoluteString
                    print("download url returned: \(urlString)")
                    completion(.success(urlString))
                })
        })
    }
    
    public func downloadProfileImage(with email: String,
                                     completion: @escaping DownloadImageCompletion) {
        var safetyEmail = email.replacingOccurrences(of: ".", with: "-")
        safetyEmail = safetyEmail.replacingOccurrences(of: ".", with: "-")
        DispatchQueue.global().async { [weak self] in
            self?.storage.child("images/\(safetyEmail)_profile_picture.png").getData(maxSize: 50 * 1024 * 1024,
                                      completion: { (data, error) in
                                        guard let profileData = data, error == nil else {
                                            completion(.failure(StorageErrors.failedToGetImage))
                                            return
                                        }
                                        completion(.success(profileData))
                                        print("download")
                                      })
        }
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
                        
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                print(error?.localizedDescription)
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
        })
    }
    
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
        case failedToGetImage
    }
}


