import DOLabel
import UIKit

class ViewController: UIViewController {
    @IBOutlet var textLabel: DOLabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.insets = .init(top: 30, left: 30, bottom: 30, right: 30)
        textLabel?.textBackground = UIColor(white: 0.7, alpha: 1.0)
        textLabel?.layer.backgroundColor = UIColor(white: 0.9, alpha: 1.0).cgColor
    }
}
