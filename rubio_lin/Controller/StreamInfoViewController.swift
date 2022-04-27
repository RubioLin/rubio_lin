import UIKit

class StreamInfoViewController: UIViewController {
    @IBOutlet weak var streamLiveCover: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStreamInfoView()
        setStreamLiveCover()
    }
    
    func setStreamInfoView() {
        self.view.layer.cornerRadius = self.view.bounds.width / 16
    }
    
    func setStreamLiveCover() {
        streamLiveCover.layer.cornerRadius = streamLiveCover.bounds.width / 16
    }
}
