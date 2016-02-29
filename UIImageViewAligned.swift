//
//  UIImageViewAligned.swift
//  UIImageViewAlignedSwift
//
//  Created by Piotr Sochalewski on 08.02.2016.
//  MIT License.
//

import UIKit

public struct UIImageViewAlignmentMask: OptionSetType {
    
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
    case None
    
    /**
     The option to enable upscaling.
     
     Used only if `contentMode` has `.Scale` preffix.
     */
    case Up
    
    /**
     The option to enable downscaling.
     
     Used only if `contentMode` has `.Scale` preffix.
     */
    case Down
    
}

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
     
     Used only if `contentMode` has `.Scale` preffix.
     */
    public var scaling: UIImageViewScaling = .None
    
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
        realImageView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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
            realFrame.origin.x = CGRectGetMaxX(bounds) - realFrame.size.width
        }
        
        if alignment.contains(.Top)  {
            realFrame.origin.y = 0.0
        } else if alignment.contains(.Bottom)  {
            realFrame.origin.y = CGRectGetMaxY(bounds) - realFrame.size.height
        }
        
        realImageView?.frame = realFrame
        
        // Make sure we clear the contents of this container layer, since it refreshes from the image property once in a while.
        layer.contents = nil
    }
    
    public override func layoutSubviews() {
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
        case .ScaleAspectFit, .ScaleAspectFill:
            var scale = min(scaleX, scaleY)
            
            if (scale > 1.0 && scaling == .Up) || (scale < 1.0 && scaling == .Down) {
                scale = 1.0
            }
            
            size = CGSize(width: (realImageView?.image?.size.width)! * scale, height: (realImageView?.image?.size.height)! * scale)
            
        case .ScaleToFill:
            if (scaleX > 1.0 && scaling == .Up) || (scaleX < 1.0 && scaling == .Down) {
                scaleX = 1.0
                scaleY = 1.0
            }
            
            size = CGSize(width: (realImageView?.image?.size.width)! * scaleX, height: (realImageView?.image?.size.height)! * scaleY)
            
        default:
            size = (realImageView?.image?.size)!
        }
        
        return size
    }
    
    // MARK: - UIImageView overloads
    
    public override var highlighted: Bool {
        set {
            super.highlighted = newValue
            layer.contents = nil
        }
        get {
            return super.highlighted
        }
    }
    
}