import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift

// MARK: - FireStore Modal
struct UserInfo: Codable {
    let nickname: String
    let email: String
    let password: String
    let userPhotoUrl: URL
}

struct FollowInfo: Codable {
    var FollowList: [FollowList]
}

struct FollowList: Codable {
    let streamerId: Int
    let streamerName: String
}

// MARK: - Firebase Manager
class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    weak var delegate: FirebaseManagerDelegate?
    
    private var db = Firestore.firestore()
    var userInfo: UserInfo?
    var followList: FollowInfo?
    var isSignIn: Bool {
        get {
            if Auth.auth().currentUser != nil {
                return true
            } else {
                return false
            }
        }
        set { }
    }
    // 獲取當前使用者資訊
    func getUserInfo() {
        if Auth.auth().currentUser != nil {
            if let currentEmail = Auth.auth().currentUser?.email {
                self.db.collection("userInfo").document(currentEmail).getDocument { user, error in
                    guard user?.exists != nil else {
                        print("無此使用者資料")
                        return
                    }
                    self.userInfo = try? user?.data(as: UserInfo.self)
                    self.delegate?.getUserInfoFinishReload()
                }
            }
        }
    }
    // 登入使用者
    func signInUser(_ email: String,_ password: String, completionHandler: @escaping (Error?) -> Void ) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error == nil {
                self.isSignIn = true
                completionHandler(nil)
            } else {
                self.isSignIn = false
                completionHandler(error)
            }
        }
    }
    // 登出使用者
    func signOutUser() {
        do {
            try Auth.auth().signOut()
            self.isSignIn = false
        } catch {
            print("登出失敗")
            print("Error: \(error)")
        }
    }
    // 註冊使用者
    func signUpUser(_ email: String,_ password: String, completionHandler: @escaping (Error?) -> Void ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error == nil {
                self.isSignIn = true
                completionHandler(nil)
            } else {
                self.isSignIn = false
                completionHandler(error)
            }
        }
    }
    // 上傳使用者資訊
    func uploadUserInfo(_ nickname: String,_ email: String,_ password: String,_ avatarUrl: URL) {
        let newUser = UserInfo(nickname: nickname, email: email, password: password, userPhotoUrl: avatarUrl)
        do {
            try db.collection("userInfo").document("\(email)").setData(from: newUser)
        } catch {
            print("錯誤：使用者資訊上傳錯誤")
            print("Error：\(error.localizedDescription)")
        }
    }
    // 上傳使用者頭像
    func uploadUserAvatar(_ avatar: UIImage,_ email: String, completion: @escaping (Result<URL, Error>) -> Void ) {
        let fileReference = Storage.storage().reference().child("\(email).jpg")
        if let data = avatar.jpegData(compressionQuality: 0.6) {
            fileReference.putData(data, metadata: nil) { result in
                switch result {
                case .success(_):
                    fileReference.downloadURL { result in
                        switch result {
                        case .success(let url):
                            completion(.success(url))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    // 上傳追蹤資訊
    func uploadUserFollowList(_ streamerId: Int,_ streamerName: String) {
        let newFollower = [["streamerId": streamerId,"streamerName": streamerName]] as [Any]
        //沒有此 colleciton 和 document 會新增
        db.collection("followInfo").document("\(Auth.auth().currentUser!.email!)").setData(["FollowList" : FieldValue.arrayUnion(newFollower)],merge: true)
        // 效果大致相同，唯一不同在沒有collection和document的情況下這個會沒用
//        db.collection("followInfo").document("\(Auth.auth().currentUser!.email!)").updateData(["FollowList" : FieldValue.arrayUnion(newFollower)])
    }
    // 取得追蹤資訊
    func getUserFollowList() {
        db.collection("followInfo").document("\(Auth.auth().currentUser!.email!)").getDocument { follower, error in
            if error == nil {
                self.followList = try? follower?.data(as: FollowInfo.self)
            } else {
                print("解析失敗")
            }
        }
    }
    // 刪除追蹤資訊
    func deleteUserFollowList(_ streamerId: Int,_ streamerName: String) {
        let removeFollower = [["streamerId": streamerId,"streamerName": streamerName]] as [Any]
        db.collection("followInfo").document("\(Auth.auth().currentUser!.email!)").updateData(["FollowList" : FieldValue.arrayRemove(removeFollower)])
        }
    
}

protocol FirebaseManagerDelegate: NSObject {
    
    func getUserInfoFinishReload()
}

