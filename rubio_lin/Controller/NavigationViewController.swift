import UIKit
import FirebaseAuth

class NavigationViewController: UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 判斷有無使用者決定要去哪個頁面
        if Auth.auth().currentUser != nil {
            let accountPage = self.storyboard?.instantiateViewController(withIdentifier:"AccountPage")
            self.viewControllers = [accountPage!]
            print("有用戶")
        } else {
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier:"SignInPage")
            self.viewControllers = [signInPage!]
            print("無用戶")
        }
    }
}
