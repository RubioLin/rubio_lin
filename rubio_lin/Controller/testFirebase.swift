//
//  testFirebase.swift
//  rubio_lin
//
//  Created by Class on 2022/4/8.
//

// MARK: - 應該儲存的使用者資訊
// user.uid: String
// Nickname: String
// Email: String
// Password: String
// Photo: String

// MARK: - 上傳時機
// 按下註冊時上傳



import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift

struct UserInfo: Codable, Identifiable {
    var id: String?
    let nickName: String
    let email: String
    let passWord: String
    let photo: String?
}


class testFirebase: UIViewController {
    @IBOutlet weak var nicknameL: UILabel!
    @IBOutlet weak var emailL: UILabel!
    @IBOutlet weak var passwordL: UILabel!
    @IBOutlet weak var userhaedphoto: UIImageView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var capture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setUserInfo() {
        let db = Firestore.firestore()
        db.collection("userInfo").getDocuments { [self] snapshot, error in
            guard let snapshot = snapshot else {
                print(error?.localizedDescription)
                return
            }
            snapshot.documents.forEach { snapshot in
                nicknameL.text = "\(snapshot.data()["nickName"]!)"
                emailL.text = "\(snapshot.data()["email"]!)"
                passwordL.text = "\(snapshot.data()["passWord"]!)"
                let b = snapshot.data()["photo"] as! String
                print(b)
                if let url = URL(string: b) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            DispatchQueue.main.async {
                                self.userhaedphoto.image = UIImage(data: data)
                        }
                        }
                    }.resume()
                }
            }
        }
        
    }
    @IBAction func d(_ sender: Any) {
        setUserInfo()
    }
    
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        if let data = image.jpegData(compressionQuality: 0.9) {
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
    @IBAction func b(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        let sources:[(name:String, type:UIImagePickerController.SourceType)] = [
            ("Album", .photoLibrary),
            ("Camera", .camera)
        ]
        for source in sources {
            let action = UIAlertAction(title: source.name, style: .default) { (_) in
                self.selectPhoto(sourceType: source.type)
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func c(_ sender: Any) {
        let uiImage = selectedImage.image
        uploadPhoto(image: uiImage!) { result in
            switch result {
            case .success(let url):
                print(url)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //upload user info to firestore
    @IBAction func a(_ sender: Any) {
        let db = Firestore.firestore()
        let user1 = UserInfo(id: "user.uid", nickName: "\(nickname.text!)", email: "\(email.text!)", passWord: "\(password.text!)", photo: "https://i.epochtimes.com/assets/uploads/2021/08/id13156667-shutterstock_376153318-450x322.jpg")
        do {
            try db.collection("userInfo").document("\(user1.nickName)").setData(from: user1)
            print("成功")
        } catch {
            print(error)
        }
    }
    
    
}

extension testFirebase: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    func selectPhoto(sourceType: UIImagePickerController.SourceType) {
        let ImagePickerController = UIImagePickerController()
        ImagePickerController.sourceType = sourceType
        ImagePickerController.delegate = self
        present(ImagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        capture = info[.originalImage] as? UIImage
        selectedImage.image = capture
        dismiss(animated: true,completion: nil)
    }
    
}
