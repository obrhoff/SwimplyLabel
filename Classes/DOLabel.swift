//
//  DOLabel.swift
//  DOLabel
//
//  Created by Dennis Oberhoff on 04/03/2018.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import AppKit
import Foundation

open class DOLabel: NSView {
    private static let cache = NSCache<NSString, NSValue>()
    private var drawingRect: CGRect = .zero

    public init() {
        super.init(frame: NSRect.zero)
        commonInit()
    }

    public override init(frame _: NSRect) {
        super.init(frame: NSRect.zero)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        wantsLayer = true
        canDrawConcurrently = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
    }

    open override func draw(_: NSRect) {
        let bounds = self.bounds
        var drawRect: NSRect = .zero
        drawRect.origin = drawingRect.origin
        drawRect.size = bounds.size

        drawRect.origin.x += margins.left
        drawRect.origin.y += margins.top

        drawRect.size.width -= (margins.right + margins.left)
        drawRect.size.height -= (margins.bottom + margins.top)

        backgroundColor.setFill()

        let operation: NSCompositingOperation = .sourceOver
        __NSRectFillUsingOperation(bounds, operation)

        (text as NSString?)?.draw(with: drawRect, options: drawingOptions,
                                  attributes: defaultAttributedDict, context: nil)
    }

    private func calculateRect() {
        defer {
            invalidateIntrinsicContentSize()
            needsDisplay = true
        }
        let cacheKey = "\(text ?? "")-\(font.fontName)-\(font.pointSize)" +
            "\(textAlignment.rawValue)-\(lineSpacing ?? 0)-\(numberOfLines)" +
            "\(lineBreakMode)-\(preferredMaxLayoutWidth ?? bounds.width)-" as NSString

        if let cachedSize = DOLabel.cache.object(forKey: cacheKey) {
            drawingRect = cachedSize.rectValue
            return
        }

        let size = NSSize(width: preferredMaxLayoutWidth ?? bounds.width, height: 0.0)
        drawingRect = (text as NSString?)?.boundingRect(with: size, options: drawingOptions,
                                                        attributes: defaultAttributedDict) ?? .zero

        drawingRect.origin.x = ceil(-drawingRect.origin.x)
        drawingRect.origin.y = ceil(-drawingRect.origin.y)
        drawingRect.size.width = ceil(drawingRect.size.width) + (margins.left + margins.right)
        drawingRect.size.height = ceil(drawingRect.size.height) + (margins.top + margins.bottom)
        DOLabel.cache.setObject(NSValue(rect: drawingRect), forKey: cacheKey)
    }

    open override var baselineOffsetFromBottom: CGFloat {
        return drawingRect.origin.y
    }

    open override var intrinsicContentSize: NSSize {
        return drawingRect.size
    }

    open var drawingOptions: NSString.DrawingOptions {
        return numberOfLines == 0 ? [.usesFontLeading, .usesLineFragmentOrigin] : [.usesFontLeading]
    }

    open var drawingParagraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        style.lineSpacing = lineSpacing ?? style.lineSpacing
        style.lineBreakMode = numberOfLines > 0 ? lineBreakMode : style.lineBreakMode
        return style
    }

    private var defaultAttributedDict: [NSAttributedStringKey: Any] {
        return [
            NSAttributedStringKey.font: self.font,
            NSAttributedStringKey.foregroundColor: self.textColor,
            NSAttributedStringKey.backgroundColor: self.backgroundColor,
            NSAttributedStringKey.paragraphStyle: self.drawingParagraphStyle,
        ]
    }

    open override func layout() {
        super.layout()
        display()
    }

    open override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        let scale = window?.backingScaleFactor ?? 1.0
        layer?.contentsScale = scale
        layer?.rasterizationScale = scale
    }

    @IBInspectable open var text: String? {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var textColor = NSColor.black {
        didSet {
            needsDisplay = true
        }
    }

    @IBInspectable open var backgroundColor = NSColor.clear {
        didSet {
            needsDisplay = true
        }
    }

    @IBInspectable open var font = NSFont.systemFont(ofSize: 14) {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var textAlignment: NSTextAlignment = .left {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var lineBreakMode: NSParagraphStyle.LineBreakMode = .byTruncatingTail {
        didSet {
            calculateRect()
        }
    }

    open var lineSpacing: CGFloat? {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var numberOfLines = 0 {
        didSet {
            calculateRect()
        }
    }

    open var preferredMaxLayoutWidth: CGFloat? {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var margins: NSEdgeInsets = NSEdgeInsetsZero {
        didSet {
            calculateRect()
        }
    }
}
