//
//  DOLabel-OSX.swift
//  DOLabel-iOS
//
//  Created by Dennis Oberhoff on 06.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Foundation
import QuartzCore

extension DOLabel: CALayerDelegate {
    public func draw(_: CALayer, in ctx: CGContext) {
        draw(context: ctx)
    }

    open override func makeBackingLayer() -> CALayer {
        return DOLayer()
    }

    open override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        let scale = window?.backingScaleFactor ?? 1.0
        let isRetina = scale >= 2.0
        shouldSmoothFonts = true
        shouldAntialias = true
        shouldSubpixelPositionFonts = !isRetina
        shouldSubpixelQuantizeFonts = !isRetina
        layer?.contentsScale = scale
        layer?.rasterizationScale = scale
        layer?.setNeedsDisplay()
    }

    open override var isFlipped: Bool {
        return true
    }
}
