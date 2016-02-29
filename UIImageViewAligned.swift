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
    
    public static let Center = UIImageViewAlignmentMask(rawValue: 0)
    public static let Left = UIImageViewAlignmentMask(rawValue: 1)
    public static let Right = UIImageViewAlignmentMask(rawValue: 2)
    public static let Top = UIImageViewAlignmentMask(rawValue: 4)
    public static let Bottom = UIImageViewAlignmentMask(rawValue: 8)
    public static let TopLeft: UIImageViewAlignmentMask = [Top, Left]
    public static let TopRight: UIImageViewAlignmentMask = [Top, Right]
    public static let BottomLeft: UIImageViewAlignmentMask = [Bottom, Left]
    public static let BottomRight: UIImageViewAlignmentMask = [Bottom, Right]
    
}

public class UIImageViewAligned: UIImageView {
    
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
    public var enableScaleUp = false
    public var enableScaleDown = false
    
    private var realImageView: UIImageView?
    
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
        case .ScaleAspectFit:
            var scale = min(scaleX, scaleY)
            
            if (scale > 1.0 && enableScaleUp) || (scale < 1.0 && enableScaleDown) {
                scale = 1.0
            }
            
            size = CGSize(width: (realImageView?.image?.size.width)! * scale, height: (realImageView?.image?.size.height)! * scale)
            
        case .ScaleAspectFill:
            var scale = max(scaleX, scaleY)
            
            if (scale > 1.0 && enableScaleUp) || (scale < 1.0 && enableScaleDown) {
                scale = 1.0
            }
            
            size = CGSize(width: (realImageView?.image?.size.width)! * scale, height: (realImageView?.image?.size.height)! * scale)
            
        case .ScaleToFill:
            if (scaleX > 1.0 && enableScaleUp) || (scaleX < 1.0 && enableScaleDown) {
                scaleX = 1.0
            }
            if (scaleY > 1.0 && enableScaleUp) || (scaleY < 1.0 && enableScaleDown) {
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