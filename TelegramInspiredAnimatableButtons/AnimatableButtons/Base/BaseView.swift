//
//  BaseView.swift
//  TelegramInspiredAnimatableButtons
//
//  Created by Sergey Zapuhlyak on 12.10.2022.
//

import UIKit

open class BaseView: UIView {
    
    private var oldBounds: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
    
        if bounds != oldBounds {
            
            layoutSubviewsChangedBounds()
            oldBounds = bounds
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    
    open func setup() {

    }
    
    open func layoutSubviewsChangedBounds() {
    }
}
