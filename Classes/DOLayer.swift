//
//  TextLayer.swift
//  DOLabel-iOS
//
//  Created by Dennis Oberhoff on 06.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Foundation
import QuartzCore

internal class DOLayer: CALayer {
    weak var textLabel: DOLabel?
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        textLabel?.draw(context: ctx)
        ctx.restoreGState()
        super.draw(in: ctx)
    }
}
