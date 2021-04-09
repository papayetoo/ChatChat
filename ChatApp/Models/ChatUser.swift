//
//  ChatUser.swift
//  ChatApp
//
//  Created by 최광현 on 2021/04/07.
//

import Foundation

struct ChatUser {
    let name: String
    let emailAddress: String
    let profileDownloadURL: String
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    var profileImageFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
