//
//  UIImageViewAligned.swift
//  UIImageViewAlignedSwift
//
//  Created by Piotr Sochalewski on 08.02.2016.
//  MIT License.
//

import UIKit

public struct UIImageViewAlignmentMask: OptionSetType {
    
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    
    static let Center = UIImageViewAlignmentMask(rawValue: 0)
    static let Left = UIImageViewAlignmentMask(rawValue: 1)
    static let Right = UIImageViewAlignmentMask(rawValue: 2)
    static let Top = UIImageViewAlignmentMask(rawValue: 4)
    static let Bottom = UIImageViewAlignmentMask(rawValue: 8)
    static let TopLeft: UIImageViewAlignmentMask = [Top, Left]
    static let TopRight: UIImageViewAlignmentMask = [Top, Right]
    static let BottomLeft: UIImageViewAlignmentMask = [Bottom, Left]
    static let BottomRight: UIImageViewAlignmentMask = [Bottom, Right]
    
}

public class UIImageViewAligned: UIImageView {
    
    var alignment: UIImageViewAlignmentMask = .Center {
        didSet {
            if alignment == oldValue { return }
            setNeedsLayout()
        }
    }
    override var image: UIImage? {
        set {
            realImageView?.image = newValue
            setNeedsLayout()
        }
        get {
            return realImageView?.image
        }
    }
    var enableScaleUp = false
    var enableScaleDown = false
    
    private var realImageView: UIImageView?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        commonInit()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    override func layoutSubviews() {
        let realSize = realContentSize()
        
        var realFrame = CGRect(x: (bounds.size.width - realSize.width) / 2.0,
            y: (bounds.size.height - realSize.height) / 2.0,
            width: realSize.width,
            height: realSize.height)
        
        print(alignment)
        
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
    
    override var highlighted: Bool {
        set {
            super.highlighted = newValue
            layer.contents = nil
        }
        get {
            return super.highlighted
        }
    }
    
}