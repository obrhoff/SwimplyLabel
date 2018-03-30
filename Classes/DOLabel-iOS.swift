//
//  DOLabel-iOS.swift
//  DOLabel
//
//  Created by Dennis Oberhoff on 06/03/2018.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Foundation
import QuartzCore

extension DOLabel {
    open override func draw(_: CALayer, in ctx: CGContext) {
        draw(context: ctx)
    }

    open override static var layerClass: AnyClass {
        return DOLayer.self
    }
}
