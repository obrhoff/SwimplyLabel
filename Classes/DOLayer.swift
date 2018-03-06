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
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        delegate?.draw?(self, in: ctx)
        ctx.restoreGState()
    }
}
