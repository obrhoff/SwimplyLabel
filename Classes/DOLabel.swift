//
//  DOLabel.swift
//  DOLabel
//
//  Created by Dennis Oberhoff on 04/03/2018.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import CoreText
import Foundation

#if os(iOS)
    import UIKit
    public typealias Rect = CGRect
    public typealias Size = CGSize
    public typealias EdgeInsets = UIEdgeInsets
    public typealias Font = UIFont
    public typealias View = UIView
    public typealias Color = UIColor
    public typealias LineBreakMode = NSLineBreakMode
    public typealias LayoutPriority = UILayoutPriority
#elseif os(OSX)
    import AppKit
    public typealias Rect = NSRect
    public typealias Size = NSSize
    public typealias EdgeInsets = NSEdgeInsets
    public typealias Font = NSFont
    public typealias View = NSView
    public typealias Color = NSColor
    public typealias LineBreakMode = NSParagraphStyle.LineBreakMode
    public typealias LayoutPriority = NSLayoutConstraint.Priority
#endif

@IBDesignable open class DOLabel: View {
    private var drawingRect: CGRect = .zero
  
    public init() {
        super.init(frame: Rect.zero)
        commonInit()
    }

    public override init(frame _: Rect) {
        super.init(frame: Rect.zero)
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
        #if os(iOS)
            clipsToBounds = false
            layer.contentsScale = UIScreen.main.scale
            layer.rasterizationScale = UIScreen.main.scale
        #elseif os(OSX)
            wantsLayer = true
            canDrawConcurrently = true
            layerContentsRedrawPolicy = .onSetNeedsDisplay
        #endif
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        labelLayer?.drawsAsynchronously = true
        labelLayer?.textLabel = self
    }

    internal func draw(context: CGContext) {
        context.textMatrix = .identity
        context.setShouldAntialias(true)
        context.setShouldSmoothFonts(true)
        context.setAllowsFontSubpixelPositioning(true)
        context.setShouldSubpixelQuantizeFonts(true)

        #if os(iOS)
            context.translateBy(x: 0, y: bounds.height)
            context.scaleBy(x: 1.0, y: -1.0)
        #endif

        let mutablePath = CGMutablePath()
        mutablePath.move(to: CGPoint(x: drawingRect.minX + insets.left, y: drawingRect.minY + insets.bottom))
        mutablePath.addLine(to: CGPoint(x: drawingRect.maxX - insets.right, y: drawingRect.minY + insets.bottom))
        mutablePath.addLine(to: CGPoint(x: drawingRect.maxX - insets.right, y: drawingRect.maxY - insets.top))
        mutablePath.addLine(to: CGPoint(x: drawingRect.minX + insets.left, y: drawingRect.maxY - insets.top))
        mutablePath.closeSubpath()

        let attributedString = NSAttributedString(string: text ?? "", attributes: defaultAttributedDict)
        let setter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        let frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attributedString.length), mutablePath, nil)
        CTFrameDraw(frame, context)
    }

    internal func calculateRect() {
        defer {
            invalidateIntrinsicContentSize()
            updateDisplay()
        }
        let width = max(0, (preferredMaxLayoutWidth ?? bounds.width) - insets.left - insets.right)
        let attributedString = NSAttributedString(string: text ?? "", attributes: defaultAttributedDict)

        let setter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(setter, CFRange(location: 0, length: attributedString.length), nil,
                                                                CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), nil)

        drawingRect.size.width = ceil(size.width + insets.left + insets.right)
        drawingRect.size.height = ceil(size.height + insets.top + insets.bottom)
    }

    private var defaultAttributedDict: [NSAttributedStringKey: Any] {
        var attributes = [
            NSAttributedStringKey.font: self.font,
            NSAttributedStringKey.foregroundColor: self.textColor,
            NSAttributedStringKey.backgroundColor: self.textBackground,
            NSAttributedStringKey.paragraphStyle: self.drawingParagraphStyle,
            NSAttributedStringKey.kern: self.kerning,
        ] as [NSAttributedStringKey: Any]

        if let shadow = textShadow {
            attributes[NSAttributedStringKey.shadow] = shadow
        }
        return attributes
    }

    open override var intrinsicContentSize: Size {
        return drawingRect.size
    }

    open var drawingParagraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        style.lineSpacing = lineSpacing
        return style
    }

    private var labelLayer: DOLayer? {
        return layer as? DOLayer
    }

    @IBInspectable open var text: String? {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var textColor = Color.black {
        didSet {
            updateDisplay()
        }
    }

    @IBInspectable open var textBackground = Color.clear {
        didSet {
            updateDisplay()
        }
    }

    open var textShadow: NSShadow? {
        didSet {
            updateDisplay()
        }
    }

    @IBInspectable open var font = Font.systemFont(ofSize: 14) {
        didSet {
            calculateRect()
        }
    }

    open var textAlignment: NSTextAlignment = .left {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var numberOfLines = 1 {
        didSet {
            calculateRect()
        }
    }

    open var preferredMaxLayoutWidth: CGFloat? {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var lineSpacing: CGFloat = 0.0 {
        didSet {
            calculateRect()
        }
    }

    @IBInspectable open var kerning: CGFloat = 0.0 {
        didSet {
            calculateRect()
        }
    }

    open var lineBreakMode: LineBreakMode = .byTruncatingTail {
        didSet {
            calculateRect()
        }
    }

    open var insets: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            calculateRect()
        }
    }
}
