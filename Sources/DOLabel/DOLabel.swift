import CoreText
import Foundation

#if os(iOS) || os(tvOS)
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
    public typealias LineBreakMode = NSLineBreakMode
    public typealias LayoutPriority = NSLayoutConstraint.Priority
#endif

@IBDesignable open class DOLabel: View {
    private var shouldAntialias = true
    private var shouldSmoothFonts = true
    private var shouldSubpixelPositionFonts = false
    private var shouldSubpixelQuantizeFonts = false

    open override var intrinsicContentSize: Size {
        return drawingRect.size
    }

    private var labelLayer: DOLayer? {
        return layer as? DOLayer
    }

    private var defaultAttributedDict: [NSAttributedString.Key: Any] {
        var attributes = [
            .font: font,
            .foregroundColor: textColor,
            .backgroundColor: textBackground,
            .paragraphStyle: drawingParagraphStyle,
            .kern: kerning,
        ] as [NSAttributedString.Key: Any]

        if let shadow = textShadow {
            attributes[.shadow] = shadow
        }
        return attributes
    }

    private var drawingParagraphStyle: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        style.lineSpacing = lineSpacing
        return style
    }

    private var drawingRect: CGRect = .zero {
        didSet {
            if oldValue == drawingRect { return }
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable open var text: String? {
        didSet {
            if oldValue == text { return }
            needsContentDisplay()
        }
    }

    @IBInspectable open var textColor = Color.black {
        didSet {
            if oldValue == textColor { return }
            needsContentDisplay()
        }
    }

    @IBInspectable open var textBackground = Color.clear {
        didSet {
            if oldValue == textBackground { return }
            self.needsContentDisplay()
        }
    }

    open var textShadow: NSShadow? {
        didSet {
            if oldValue == textShadow { return }
            needsContentDisplay()
        }
    }

    @IBInspectable open var font = Font.systemFont(ofSize: 14) {
        didSet {
            if oldValue == font { return }
            needsContentDisplay()
        }
    }

    open var textAlignment: NSTextAlignment = .left {
        didSet {
            if oldValue == textAlignment { return }
            needsContentDisplay()
        }
    }

    @IBInspectable open var numberOfLines = 1 {
        didSet {
            if oldValue == numberOfLines { return }
            needsContentDisplay()
        }
    }

    open var preferredMaxLayoutWidth: CGFloat? {
        didSet {
            if oldValue == preferredMaxLayoutWidth { return }
            needsContentDisplay()
        }
    }

    @IBInspectable open var lineSpacing: CGFloat = 0.0 {
        didSet {
            if oldValue == lineSpacing { return }
            needsContentDisplay()
        }
    }

    @IBInspectable open var kerning: CGFloat = 0.0 {
        didSet {
            if oldValue == kerning { return }
            needsContentDisplay()
        }
    }

    @IBInspectable open var lineBreakMode: LineBreakMode = .byTruncatingTail {
        didSet {
            if oldValue == lineBreakMode { return }
            needsContentDisplay()
        }
    }

    @IBInspectable open var insets: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            needsContentDisplay()
        }
    }

    public override init(frame: Rect) {
        super.init(frame: frame)
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
}

private extension DOLabel {
    func commonInit() {
        _ = DOLabel.Cache.shared

        #if os(iOS)
            let isRetina = UIScreen.main.scale >= 2.0
            shouldSubpixelPositionFonts = !isRetina
            shouldSubpixelQuantizeFonts = !isRetina
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
        labelLayer?.needsDisplayOnBoundsChange = true
        labelLayer?.delegate = self
    }

    func draw(context: CGContext) {
        calculateContentSize()

        context.textMatrix = .identity
        context.setAllowsAntialiasing(true)
        context.setAllowsFontSmoothing(true)
        context.setAllowsFontSubpixelPositioning(true)
        context.setAllowsFontSubpixelQuantization(true)

        context.setShouldAntialias(shouldAntialias)
        context.setShouldSmoothFonts(shouldSmoothFonts)
        context.setShouldSubpixelPositionFonts(shouldSubpixelPositionFonts)
        context.setShouldSubpixelQuantizeFonts(shouldSubpixelQuantizeFonts)

        context.translateBy(x: 0, y: bounds.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let height = min(drawingRect.height, bounds.height) - insets.bottom - insets.top
        let width = drawingRect.width - insets.left - insets.right

        let rect = CGRect(x: insets.left, y: insets.bottom, width: width, height: height)
        let drawingPath = CGPath(rect: rect, transform: nil)

        let attributedString = NSAttributedString(string: text ?? "", attributes: defaultAttributedDict)
        let setter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        let frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attributedString.length), drawingPath, nil)
        CTFrameDraw(frame, context)
    }

    func calculateContentSize() {
        if text == nil || text?.isEmpty == true {
            drawingRect = .zero
            return
        }

        let width = max(0, (preferredMaxLayoutWidth ?? bounds.width) - insets.left - insets.right)
        let cacheItem = CacheItem(width: width, text: text ?? "", alignment: textAlignment,
                                  lineSpacing: lineSpacing, kerning: kerning, pointSize: font.pointSize)

        if let cachedSize = Cache.shared.storage[cacheItem] {
            drawingRect = cachedSize
            return
        }

        let attributedString = NSMutableAttributedString(string: text ?? "", attributes: defaultAttributedDict)

        let setter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        var size = CTFramesetterSuggestFrameSizeWithConstraints(setter, CFRange(location: 0, length: attributedString.length), nil,
                                                                CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), nil)
        if numberOfLines > 1 {
            let path = CGPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), transform: nil)
            let ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), path, nil)
            let currentLines = CFArrayGetCount(CTFrameGetLines(ctFrame)) as Int
            let calculatedHeight = (size.height / CGFloat(currentLines)) * CGFloat(numberOfLines)
            size.height = min(size.height, calculatedHeight)
        }

        let rect = CGRect(x: 0, y: 0, width: ceil(size.width + insets.left + insets.right),
                          height: ceil(size.height + insets.top + insets.bottom))

        Cache.shared.storage[cacheItem] = rect
        drawingRect = rect
    }

    func needsContentDisplay() {
        calculateContentSize()
        labelLayer?.setNeedsDisplay()
    }
}

private extension DOLabel {
    class DOLayer: CALayer {
        override func draw(in ctx: CGContext) {
            ctx.saveGState()
            delegate?.draw?(self, in: ctx)
            ctx.restoreGState()
        }
    }

    struct CacheItem: Hashable {
        let width: CGFloat
        let text: String
        let alignment: NSTextAlignment
        let lineSpacing: CGFloat
        let kerning: CGFloat
        let pointSize: CGFloat
    }

    class Cache {
        var storage = [CacheItem: CGRect]()
        let pressure = DispatchSource.makeMemoryPressureSource(eventMask: .all, queue: .main)

        static let shared = Cache()

        private init() {
            let cleanup = { [weak self] (_: Notification) -> Void in
                self?.storage.removeAll()
            }

            pressure.setEventHandler { [weak self] in
                self?.storage.removeAll()
            }

            pressure.resume()

            var notifications: [NSNotification.Name] = []

            #if os(OSX)
                notifications += [NSWindow.didMiniaturizeNotification, NSApplication.didHideNotification]
            #elseif os(iOS) || os(tvOS)
                notifications += [UIApplication.didEnterBackgroundNotification]
            #endif

            notifications.forEach {
                NotificationCenter.default.addObserver(forName: $0, object: nil, queue: .main, using: cleanup)
            }
        }
    }
}

#if os(OSX)
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
#endif

#if os(iOS) || os(tvOS)
    extension DOLabel {
        open override func draw(_: CALayer, in ctx: CGContext) {
            draw(context: ctx)
        }

        public override static var layerClass: AnyClass {
            return DOLayer.self
        }
    }
#endif
