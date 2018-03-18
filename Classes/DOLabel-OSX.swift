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
        layer?.contentsScale = scale
        layer?.rasterizationScale = scale
        setNeedsDisplayLayer()
    }

    open override func layout() {
        super.layout()
        calculateRect()
    }

    open override var isFlipped: Bool {
        return false
    }

    open override var wantsDefaultClipping: Bool {
        return false
    }
}
