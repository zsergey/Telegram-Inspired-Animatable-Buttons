//
//  BaseLayer.swift
//  TelegramInspiredAnimatableButtons
//
//  Created by Sergey Zapuhlyak on 15.10.2022.
//

import UIKit

open class BaseLayer: CALayer {
    
    var animationDuration: CGFloat {
        0.3
    }
    
    override init(layer: Any) {
        super.init(layer: layer)

        setup(from: layer)
    }
    
    override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override class func needsDisplay(forKey key: String) -> Bool {
        if isAnimationKeySupported(key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }

    open override func action(forKey event: String) -> CAAction? {
        if Self.isAnimationKeySupported(event) {

            let animation = CABasicAnimation(keyPath: event)

            if let presentation = presentation() {
                animation.fromValue = presentation.value(forKeyPath: event)
                animation.duration = animationDuration
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            }

            return animation
        }
        return super.action(forKey: event)
    }
    
    class func isAnimationKeySupported(_ key: String) -> Bool {
        false
    }
    
    func setup(from layer: Any) {
        
    }
}
