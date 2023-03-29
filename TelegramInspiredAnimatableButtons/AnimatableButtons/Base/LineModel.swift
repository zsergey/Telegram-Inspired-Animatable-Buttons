//
//  LineModel.swift
//  TelegramInspiredAnimatableButtons
//
//  Created by Sergey Zapuhlyak on 12.10.2022.
//

import Foundation

struct LineModel: CustomStringConvertible {
    let startPoint: CGPoint
    let endPoint: CGPoint
    
    var description: String {
        "(x: \(startPoint.x), y: \(startPoint.x)); (x: \(endPoint.x), y: \(endPoint.y))"
    }
}
