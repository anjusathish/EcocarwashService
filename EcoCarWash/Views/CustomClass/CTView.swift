//
//  CTView.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 02/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CTView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    @IBInspectable var showBorder: Bool = false {
        didSet {
            if self.showBorder {
                self.addBorder()
            }
            else {
                self.removeBorder()
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = .blue {
        didSet {
            if shadowLayer != nil {
                shadowLayer.strokeColor = borderColor.cgColor
            }
        }
    }
    
    @IBInspectable var applyTintColorToInnerElements: Bool = false {
        didSet {
            for view in self.subviews {
                view.tintColor = borderColor
            }
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateView()
    }
    
    private func updateView() {
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            layer.insertSublayer(shadowLayer, at: 0)
        }
        
        if shadowLayer != nil {
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            if #available(iOS 13.0, *) {
                shadowLayer.fillColor =  UIColor.white.cgColor
            } else {
                shadowLayer.fillColor = UIColor.white.cgColor
                // Fallback on earlier versions
            }
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
        }
    }
    
    private func addBorder() {
        
        if shadowLayer != nil {
            shadowLayer.strokeColor = borderColor.cgColor
        }
    }
    
    private func removeBorder() {
        
        if shadowLayer != nil {
            shadowLayer.strokeColor = UIColor.clear.cgColor
        }
    }
    
//    private func addBackgroundColour() {
//
//        if shadowLayer != nil {
//            shadowLayer.strokeColor = UIColor.borderColor
//        }
//    }
    
}

@IBDesignable
open class UIViewIBDesignable: UIImageView {
    public override init(frame: CGRect) {
        super.init(frame: frame)

    }
    @IBInspectable public var cornerRad: CGFloat = 0.00 {
        didSet {
            self.layer.cornerRadius = cornerRad

        }
    }
    @IBInspectable public var  ShadowObjColor: UIColor = UIColor.black {
        didSet {
            addShadow(obj: self, shadColor: ShadowObjColor, shadOpacity: ShadowShadOpacity, shadOff: ShadowShadOff)
        }
    }
    @IBInspectable public var  ShadowShadOff: CGSize = CGSize.init(width: 5, height: 5) {
        didSet {
            addShadow(obj: self, shadColor: ShadowObjColor, shadOpacity: ShadowShadOpacity, shadOff: ShadowShadOff)
        }
    }
    @IBInspectable public var  ShadowShadOpacity: Float = 0.4 {
        didSet {
            addShadow(obj: self, shadColor: ShadowObjColor, shadOpacity: ShadowShadOpacity, shadOff: ShadowShadOff)
        }
    }

    @IBInspectable public var  bordColor: UIColor = UIColor.black {
        didSet {

            self.layer.borderColor = bordColor.cgColor
        }
    }

    @IBInspectable public var  bordWidth: CGFloat = 1.00 {
        didSet {

            self.layer.borderWidth = bordWidth
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
