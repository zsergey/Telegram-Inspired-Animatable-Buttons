//
//  MathExtensions.swift
//  TelegramInspiredAnimatableButtons
//
//  Created by Sergey Zapuhlyak on 13.10.2022.
//

import UIKit

extension CGFloat {
    
    var radians: CGFloat {
        CGFloat.pi * self / 180.0
    }
}

extension Int {
    
    var radians: CGFloat {
        CGFloat(self).radians
    }
}
