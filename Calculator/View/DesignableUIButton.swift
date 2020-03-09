//
//  DesignableUIButton.swift
//  RecordingMemo
//
//  Created by Anderson on 2019/3/17.
//  Copyright © 2019 Anderson. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUIButton: UIButton {

    /// A IBInspectable, can change view radius.
    @IBInspectable var viewRadius: CGFloat = 0.0 {
        didSet {
            self.layer.masksToBounds = true
            if viewRadius != -1 {
                self.layer.cornerRadius = viewRadius
            } else {
                self.layer.cornerRadius = bounds.width / 2
            }
        }
    }
    
    /// A IBInspectable, can change width of the view border.
    @IBInspectable var borderColor: UIColor = .black
    
    /// A IBInspectable, can change color of the view border.
    @IBInspectable var borderRadius: CGFloat = 0
    
    /// A IBInspectable, can change radius of the view border.
    @IBInspectable var borderWidth: CGFloat = 0
    
    /// A IBInspectable, can change style of the view border, it's a integer range is -1 ~ 1.
    @IBInspectable var borderStyleAdapter: Int = 0 {
        didSet{
            switch borderStyleAdapter {
            case 0:
                borderStyle = .butt
            case 1:
                borderStyle = .round
            case 2:
                borderStyle = .square
            default:
                break
            }
        }
    }
    
    var borderLayer: CAShapeLayer?
    var borderStyle: CAShapeLayerLineCap = .square
    
    /// This function at storyboard update called.
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        borderRadius = (borderRadius == -1 ? bounds.width / 2 : borderRadius)
        addBorder(width: borderWidth, color: borderColor, radius: borderRadius, style: borderStyle)
    }
    
    /// This function at application open called.
    override func awakeFromNib() {
        super.awakeFromNib()
        borderRadius = (borderRadius == -1 ? bounds.width / 2 : borderRadius)
        addBorder(width: borderWidth, color: borderColor, radius: borderRadius, style: borderStyle)
    }
    
    /// This function at view appear called.
    override func draw(_ rect: CGRect) {
        borderRadius = (borderRadius == -1 ? bounds.width / 2 : borderRadius)
        addBorder(width: borderWidth, color: borderColor, radius: borderRadius, style: borderStyle)
    }
    
    /// This function can add a border in the view.
    ///
    /// - Parameters:
    ///   - width: Input a width of border.
    ///   - color: Input a color of border.
    ///   - radius: Input a radius of border.
    ///   - style: Input a style of border.
    func addBorder(width: CGFloat = 0, color: UIColor?, radius: CGFloat?, style: CAShapeLayerLineCap?) {
        let pathRect = CGRect(x: width/2, y: width/2, width: bounds.width-width, height: bounds.height-width)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: radius ?? 0)
        if borderLayer != nil {
            borderLayer?.removeFromSuperlayer()
        }
        borderLayer = CAShapeLayer()
        borderLayer?.masksToBounds = true
        borderLayer?.fillColor = nil
        borderLayer?.path = path.cgPath
        borderLayer?.strokeColor = color?.cgColor
        borderLayer?.frame = self.bounds
        borderLayer?.lineWidth = width
        if (0...2).contains(borderStyleAdapter) {
            borderLayer?.lineCap = style ?? .square
            borderLayer?.lineDashPattern = [5, 5]
        }
        self.layer.addSublayer(borderLayer!)
    }

}
