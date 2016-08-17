//
//  UIImageViewAligned.swift
//  UIImageViewAlignedSwift
//
//  Created by Piotr Sochalewski on 08.02.2016.
//  MIT License.
//

import UIKit

public struct UIImageViewAlignmentMask: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    /// The option to align the content to the center.
    public static let Center = UIImageViewAlignmentMask(rawValue: 0)
    /// The option to align the content to the left.
    public static let Left = UIImageViewAlignmentMask(rawValue: 1)
    /// The option to align the content to the right.
    public static let Right = UIImageViewAlignmentMask(rawValue: 2)
    /// The option to align the content to the top.
    public static let Top = UIImageViewAlignmentMask(rawValue: 4)
    /// The option to align the content to the bottom.
    public static let Bottom = UIImageViewAlignmentMask(rawValue: 8)
    /// The option to align the content to the top left.
    public static let TopLeft: UIImageViewAlignmentMask = [Top, Left]
    /// The option to align the content to the top right.
    public static let TopRight: UIImageViewAlignmentMask = [Top, Right]
    /// The option to align the content to the bottom left.
    public static let BottomLeft: UIImageViewAlignmentMask = [Bottom, Left]
    /// The option to align the content to the bottom right.
    public static let BottomRight: UIImageViewAlignmentMask = [Bottom, Right]
}

public enum UIImageViewScaling {
    /**
     The option to disable scaling.
     */
    case none
    
    /**
     The option to enable upscaling.
     
     Used only if `contentMode` has the `.Scale` prefix.
     */
    case up
    
    /**
     The option to enable downscaling.
     
     Used only if `contentMode` has the `.Scale` prefix.
     */
    case down
}

@IBDesignable
public class UIImageViewAligned: UIImageView {
    
    /**
     The technique to use for aligning the image.
     
     Changes to this property can be animated.
     */
    public var alignment: UIImageViewAlignmentMask = .Center {
        didSet {
            if alignment != oldValue {
                updateLayout()
            }
        }
    }
    
    public override var image: UIImage? {
        set {
            realImageView?.image = newValue
            setNeedsLayout()
        }
        get {
            return realImageView?.image
        }
    }
    
    /**
     The image view's scaling.
     
     Used only if `contentMode` has the `.Scale` prefix.
     */
    public var scaling: UIImageViewScaling = .none
    
    /**
     The option to align the content to the top.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable public var alignTop: Bool {
        set {
            setInspectableProperty(newValue, alignment: .Top)
        }
        get {
            return getInspectableProperty(.Top)
        }
    }
    
    /**
     The option to align the content to the left.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable public var alignLeft: Bool {
        set {
            setInspectableProperty(newValue, alignment: .Left)
        }
        get {
            return getInspectableProperty(.Left)
        }
    }
    
    /**
     The option to align the content to the right.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable public var alignRight: Bool {
        set {
            setInspectableProperty(newValue, alignment: .Right)
        }
        get {
            return getInspectableProperty(.Right)
        }
    }
    
    /**
     The option to align the content to the bottom.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable public var alignBottom: Bool {
        set {
            setInspectableProperty(newValue, alignment: .Bottom)
        }
        get {
            return getInspectableProperty(.Bottom)
        }
    }
    
    /**
     The inner image view.
     
     It should be used only when necessary.
     Available to keep compatibility with original `UIImageViewAligned`.
     */
    private(set) var realImageView: UIImageView?
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        commonInit()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        realImageView = UIImageView(frame: bounds)
        realImageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        realImageView?.contentMode = contentMode
        addSubview(realImageView!)
        
        if super.image != nil {
            swap(&image, &super.image)
        }
    }
    
    private func updateLayout() {
        let realSize = realContentSize()
        
        var realFrame = CGRect(x: (bounds.size.width - realSize.width) / 2.0,
                               y: (bounds.size.height - realSize.height) / 2.0,
                               width: realSize.width,
                               height: realSize.height)
        
        if alignment.contains(.Left) {
            realFrame.origin.x = 0.0
        } else if alignment.contains(.Right)  {
            realFrame.origin.x = bounds.maxX - realFrame.size.width
        }
        
        if alignment.contains(.Top)  {
            realFrame.origin.y = 0.0
        } else if alignment.contains(.Bottom)  {
            realFrame.origin.y = bounds.maxY - realFrame.size.height
        }
        
        realImageView?.frame = realFrame.integral
        
        // Make sure we clear the contents of this container layer, since it refreshes from the image property once in a while.
        layer.contents = nil
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    // MARK: - Private methods
    
    private func realContentSize() -> CGSize {
        var size = bounds.size
        
        if image == nil {
            return size
        }
        
        var scaleX = size.width / (realImageView?.image?.size.width)!
        var scaleY = size.height / (realImageView?.image?.size.height)!
        
        switch contentMode {
        case .scaleAspectFill:
            var scale = max(scaleX, scaleY)
            
            if (scale > 1.0 && scaling == .up) || (scale < 1.0 && scaling == .down) {
                scale = 1.0
            }
            
            size = CGSize(width: (realImageView?.image?.size.width)! * scale, height: (realImageView?.image?.size.height)! * scale)
            
        case .scaleAspectFit:
            var scale = min(scaleX, scaleY)
            
            if (scale > 1.0 && scaling == .up) || (scale < 1.0 && scaling == .down) {
                scale = 1.0
            }
            
            size = CGSize(width: (realImageView?.image?.size.width)! * scale, height: (realImageView?.image?.size.height)! * scale)
            
        case .scaleToFill:
            if (scaleX > 1.0 && scaling == .up) || (scaleX < 1.0 && scaling == .down) {
                scaleX = 1.0
                scaleY = 1.0
            }
            
            size = CGSize(width: (realImageView?.image?.size.width)! * scaleX, height: (realImageView?.image?.size.height)! * scaleY)
            
        default:
            size = (realImageView?.image?.size)!
        }
        
        return size
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
    
    // MARK: - UIImageView overloads
    
    public override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            layer.contents = nil
        }
        get {
            return super.isHighlighted
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.contents = nil
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.contents = nil
    }
}
