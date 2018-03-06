//
//  ViewController.swift
//  DOLabel-iOS
//
//  Created by Dennis Oberhoff on 06.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

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
