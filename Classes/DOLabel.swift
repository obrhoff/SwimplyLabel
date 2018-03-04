//
//  DOLabel.swift
//  DOLabel
//
//  Created by Dennis Oberhoff on 04/03/2018.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import AppKit
import Foundation

private class TextLayer: CALayer {
    weak var textLabel: DOLabel?

    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        textLabel?.draw(context: ctx)
        ctx.restoreGState()
        super.draw(in: ctx)
    }
}

open class DOLabel: NSView {
    private var drawingRect: CGRect = .zero
    private static let sizeCache = NSCache<NSString, NSValue>()

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
        textLayer?.textLabel = self
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        setContentHuggingPriority(.fittingSizeCompression, for: .horizontal)
        setContentCompressionResistancePriority(.fittingSizeCompression, for: .horizontal)
    }

    fileprivate func draw(context: CGContext) {
        context.setShouldAntialias(true)
        context.setShouldSmoothFonts(true)
        context.setAllowsFontSubpixelPositioning(true)
        context.setShouldSubpixelQuantizeFonts(true)

        let mutablePath = CGMutablePath()
        mutablePath.move(to: CGPoint(x: drawingRect.minX + margins.left, y: drawingRect.minY + margins.bottom))
        mutablePath.addLine(to: CGPoint(x: drawingRect.maxX - margins.right, y: drawingRect.minY + margins.bottom))
        mutablePath.addLine(to: CGPoint(x: drawingRect.maxX - margins.right, y: drawingRect.maxY - margins.top))
        mutablePath.addLine(to: CGPoint(x: drawingRect.minX + margins.left, y: drawingRect.maxY - margins.top))
        mutablePath.closeSubpath()

        let attributedString = attributedText ?? NSAttributedString(string: text ?? "", attributes: defaultAttributedDict)
        let setter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        let frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attributedString.length), mutablePath, nil)
        CTFrameDraw(frame, context)
    }

    private func calculateRect() {
        defer {
            invalidateIntrinsicContentSize()
            needsDisplay = true
            displayIfNeeded()
        }
        let cacheKey = "\(text ?? "")-\(font.fontName)-\(font.pointSize)-" +
            "\(textAlignment.rawValue)-\(lineSpacing ?? 0)-\(numberOfLines)-" +
            "\(lineBreakMode)-\(preferredMaxLayoutWidth ?? bounds.width)-" +
            "\(margins)" as NSString

        if let cachedSize = DOLabel.sizeCache.object(forKey: cacheKey) {
            drawingRect = cachedSize.rectValue
            return
        }

        let width = max(0, (preferredMaxLayoutWidth ?? bounds.width) - margins.left - margins.right)
        let attributedString = attributedText ?? NSAttributedString(string: text ?? "", attributes: defaultAttributedDict)
        let setter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(setter, CFRange(location: 0, length: attributedString.length), nil,
                                                                CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), nil)

        drawingRect.size.width = ceil(size.width + margins.left + margins.right)
        drawingRect.size.height = ceil(size.height + margins.top + margins.bottom)
        DOLabel.sizeCache.setObject(NSValue(rect: drawingRect), forKey: cacheKey)
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
        style.lineBreakMode = lineBreakMode
        style.lineSpacing = lineSpacing ?? style.lineSpacing
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

    open override func makeBackingLayer() -> CALayer {
        return TextLayer()
    }

    open override func layout() {
        super.layout()
        calculateRect()
    }

    open override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        let scale = window?.backingScaleFactor ?? 1.0
        layer?.contentsScale = scale
        layer?.rasterizationScale = scale
        needsDisplay = true
    }

    private var textLayer: TextLayer? {
        return layer as? TextLayer
    }

    open override var isFlipped: Bool {
        return false
    }

    open var attributedText: NSAttributedString? {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var text: String? {
        didSet {
            calculateRect()
        }
    }

    open var textColor = NSColor.black {
        didSet {
            needsDisplay = true
        }
    }

    open var backgroundColor = NSColor.clear {
        didSet {
            needsDisplay = true
        }
    }

    open var font = NSFont.systemFont(ofSize: 14) {
        didSet {
            calculateRect()
        }
    }

    open var textAlignment: NSTextAlignment = .left {
        didSet {
            calculateRect()
        }
    }

    open var lineBreakMode: NSParagraphStyle.LineBreakMode = .byTruncatingTail {
        didSet {
            calculateRect()
        }
    }

    open var lineSpacing: CGFloat? {
        didSet {
            calculateRect()
        }
    }

    open var numberOfLines = 1 {
        didSet {
            calculateRect()
        }
    }

    open var preferredMaxLayoutWidth: CGFloat? {
        didSet {
            calculateRect()
        }
    }

    open var margins: NSEdgeInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            calculateRect()
        }
    }
}
