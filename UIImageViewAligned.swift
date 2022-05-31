//
//  UIImageViewAligned.swift
//  UIImageViewAlignedSwift
//
//  MIT License.
//

import UIKit

public struct UIImageViewAlignmentMask: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    /// The option to align the content to the center.
    public static let center = UIImageViewAlignmentMask([])
    /// The option to align the content to the left.
    public static let left = UIImageViewAlignmentMask(rawValue: 1 << 0)
    /// The option to align the content to the right.
    public static let right = UIImageViewAlignmentMask(rawValue: 1 << 1)
    /// The option to align the content to the top.
    public static let top = UIImageViewAlignmentMask(rawValue: 1 << 2)
    /// The option to align the content to the bottom.
    public static let bottom = UIImageViewAlignmentMask(rawValue: 1 << 3)
    /// The option to align the content to the top left.
    public static let topLeft: UIImageViewAlignmentMask = [top, left]
    /// The option to align the content to the top right.
    public static let topRight: UIImageViewAlignmentMask = [top, right]
    /// The option to align the content to the bottom left.
    public static let bottomLeft: UIImageViewAlignmentMask = [bottom, left]
    /// The option to align the content to the bottom right.
    public static let bottomRight: UIImageViewAlignmentMask = [bottom, right]
}

@IBDesignable
open class UIImageViewAligned: UIView {

    /**
     The technique to use for aligning the image.

     Changes to this property can be animated.
     */
    open var alignment: UIImageViewAlignmentMask = .center {
        didSet {
            guard alignment != oldValue else { return }
            updateLayout()
        }
    }

    open var image: UIImage? {
        set {
            imageView?.image = newValue
            setNeedsLayout()
        }
        get {
            return imageView?.image
        }
    }

    open var highlightedImage: UIImage? {
        set {
            imageView?.highlightedImage = newValue
            setNeedsLayout()
        }
        get {
            return imageView?.highlightedImage
        }
    }

    /**
     The option to align the content to the top.

     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignTop: Bool {
        set {
            setInspectableProperty(newValue, alignment: .top)
        }
        get {
            return getInspectableProperty(.top)
        }
    }

    /**
     The option to align the content to the left.

     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignLeft: Bool {
        set {
            setInspectableProperty(newValue, alignment: .left)
        }
        get {
            return getInspectableProperty(.left)
        }
    }

    /**
     The option to align the content to the right.

     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignRight: Bool {
        set {
            setInspectableProperty(newValue, alignment: .right)
        }
        get {
            return getInspectableProperty(.right)
        }
    }

    /**
     The option to align the content to the bottom.

     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignBottom: Bool {
        set {
            setInspectableProperty(newValue, alignment: .bottom)
        }
        get {
            return getInspectableProperty(.bottom)
        }
    }

    open var isHighlighted: Bool = false

    /**
     The inner image view.

     It should be used only when necessary.
     Accessible to keep compatibility with the original `UIImageViewAligned`.
     */
    public private(set) var imageView: UIImageView?

    private var realContentSize: CGSize {
        var size = bounds.size

        guard let image = image else { return size }

        let scaleX = size.width / image.size.width
        let scaleY = size.height / image.size.height

        switch contentMode {
        case .scaleAspectFill:
            let scale = max(scaleX, scaleY)
            size = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        case .scaleAspectFit:
            let scale = min(scaleX, scaleY)
            size = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        case .scaleToFill:
            size = CGSize(width: image.size.width * scaleX, height: image.size.height * scaleY)

        default:
            size = image.size
        }

        return size
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public init(image: UIImage?) {
        super.init(frame: .zero)
        setup(image: image)
    }

    public init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(frame: .zero)
        setup(image: image, highlightedImage: highlightedImage)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        updateLayout()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.contents = nil
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.contents = nil
        if #available(tvOS 11, iOS 11, *) {
            let currentImage = realImageView?.image
            image = UIImage()
            realImageView?.image = currentImage
        }
    }

    private func setup(image: UIImage? = nil, highlightedImage: UIImage? = nil) {
        imageView = UIImageView(image: image , highlightedImage: highlightedImage)
        imageView?.frame = bounds
        imageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView?.contentMode = contentMode
         let newImageView = UIImageView(image: image , highlightedImage: highlightedImage)
         newImageView.frame = bounds
         newImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         newImageView.contentMode = contentMode
         addSubview(newImageView)
         imageView = newImageView
    }

    private func updateLayout() {
        let realSize = realContentSize

        var realFrame = CGRect(
            origin: CGPoint(
                x: (bounds.size.width - realSize.width) / 2.0,
                y: (bounds.size.height - realSize.height) / 2.0),
            size: realSize
        )

        if alignment.contains(.left) {
            realFrame.origin.x = 0.0
        } else if alignment.contains(.right) {
            realFrame.origin.x = bounds.maxX - realFrame.size.width
        }

        if alignment.contains(.top) {
            realFrame.origin.y = 0.0
        } else if alignment.contains(.bottom) {
            realFrame.origin.y = bounds.maxY - realFrame.size.height
        }
        
        realImageView?.frame = realFrame.integral
        
        // Make sure we clear the contents of this container layer, since it refreshes from the image property once in a while.
        layer.contents = nil
        if #available(tvOS 11, iOS 11, *) {
            super.image = UIImage()
        }

    }

    private func setInspectableProperty(_ newValue: Bool, alignment: UIImageViewAlignmentMask) {
        if newValue {
            self.alignment.insert(alignment)
        } else {
            self.alignment.remove(alignment)
        }
    }

    private func getInspectableProperty(_ alignment: UIImageViewAlignmentMask) -> Bool {
        return self.alignment.contains(alignment)
    }
}
