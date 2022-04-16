//
//  Firebaser.swift
//  rubio_lin
//
//  Created by Class on 2022/4/10.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

enum UserError: Error {
    case NotLogin
    case UserNotFound
}

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let getAuth = Auth.auth()
    
    func getCurrentUser(completionHandler: @escaping (UserInfo?, Error?) -> Void ) {
        guard let currentUser = getAuth.currentUser else {
            completionHandler(nil, UserError.NotLogin)
            return }
        guard let currentEmail = currentUser.email else {
            completionHandler(nil, UserError.UserNotFound)
            return }
        
    }
    
}

struct UserInfo: Codable {
    let nickname: String
    let email: String
    let password: String
    let userPhotoUrl: URL
}
