import Cocoa
import SwimplyLabel

class ViewController: NSViewController {
    @IBOutlet var textLabel: SwimplyLabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.insets = .init(top: 30, left: 30, bottom: 30, right: 30)
        textLabel?.textBackground = NSColor(white: 0.7, alpha: 1.0)
        textLabel?.layer?.backgroundColor = NSColor(white: 0.9, alpha: 1.0).cgColor
    }
}
