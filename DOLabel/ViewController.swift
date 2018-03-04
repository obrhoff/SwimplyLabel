//
//  ViewController.swift
//  DOLabel
//
//  Created by Dennis Oberhoff on 04.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Cocoa
class ViewController: NSViewController {

    @IBOutlet var textLabel : DOLabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.margins = .init(top: 30, left: 30, bottom: 30, right: 30)
        textLabel?.backgroundColor = NSColor(white: 0.7, alpha: 1.0)
        textLabel?.layer?.backgroundColor = NSColor(white: 0.9, alpha: 1.0).cgColor
    }
}

