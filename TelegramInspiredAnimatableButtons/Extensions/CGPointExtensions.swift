//
//  Math.swift
//  TelegramInspiredAnimatableButtons
//
//  Created by Sergey Zapuhlyak on 20.10.2022.
//

import Foundation

extension CGPoint {
    
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
}
