import UIKit

class NavigationViewController: UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 判斷有無使用者決定要去哪個頁面
        if FirebaseManager.shared.isSignIn == true {
            self.viewControllers = [AccountPageViewController.shared]
        } else {
            self.viewControllers = [SignInPageViewController.shared]
        }
    }
}
