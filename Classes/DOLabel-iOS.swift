//
//  DOLabel-iOS.swift
//  DOLabel
//
//  Created by Dennis Oberhoff on 06/03/2018.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Foundation

extension DOLabel {
    open override static var layerClass: AnyClass {
        return DOLayer.self
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        calculateRect()
    }

    internal func updateDisplay() {
        layer.setNeedsDisplay()
        layer.display()
    }
}
