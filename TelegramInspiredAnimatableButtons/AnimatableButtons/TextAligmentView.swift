//
//  TextAligmentView.swift
//  TelegramInspiredAnimatableButtons
//
//  Created by Sergey Zapuhlyak on 30.10.2022.
//

import UIKit

final class TextAligmentView: BaseView {
    
    enum Aligment {
        case left
        case center
        case right
    }
    
    struct Model {
        let aligment: Aligment
        let onTap: ((Aligment) -> Void)? = nil
    }
    
    fileprivate var shapeModel: ShapeModel {
        set {
            animatableLayer.startPoint1 = newValue.firstLine.startPoint
            animatableLayer.endPoint1 = newValue.firstLine.endPoint
            
            animatableLayer.startPoint2 = newValue.secondLine.startPoint
            animatableLayer.endPoint2 = newValue.secondLine.endPoint
            
            animatableLayer.startPoint3 = newValue.thirdLine.startPoint
            animatableLayer.endPoint3 = newValue.thirdLine.endPoint

            animatableLayer.startPoint4 = newValue.fourthLine.startPoint
            animatableLayer.endPoint4 = newValue.fourthLine.endPoint
        }
        get {
            animatableLayer.shapeModel
        }
    }

    private var shapeLayer = CAShapeLayer()

    private var lineWidth: CGFloat = 2.0

    private let countLines: CGFloat = 4

    private let inset: CGFloat = 6

    private let doubleInset: CGFloat = 14

    private let gap: CGFloat = 5
    
    private let startY: CGFloat = 7.5

    private var aligment: Aligment = .left
    
    private var onTap: ((Aligment) -> Void)? = nil

    private var lastRenderedShape: ShapeModel?
    
    private var leftShapeModel: ShapeModel {
        
        var y: CGFloat = startY
        
        let firstLine = LineModel(startPoint: .init(x: inset, y: y),
                                  endPoint: .init(x: bounds.width - inset, y: y))
        
        y += gap
        let secondLine = LineModel(startPoint: .init(x: inset, y: y),
                                   endPoint: .init(x: bounds.width - doubleInset, y: y))
        
        y += gap
        let thirdLine = LineModel(startPoint: .init(x: inset, y: y),
                                  endPoint: .init(x: bounds.width - inset, y: y))
        
        y += gap
        let fourthLine = LineModel(startPoint: .init(x: inset, y: y),
                                   endPoint: .init(x: bounds.width - doubleInset, y: y))
        
        return ShapeModel(firstLine: firstLine,
                          secondLine: secondLine,
                          thirdLine: thirdLine,
                          fourthLine: fourthLine)
    }
    
    private var centerShapeModel: ShapeModel {
        
        var y: CGFloat = startY
        
        let firstLine = LineModel(startPoint: .init(x: inset, y: y),
                                  endPoint: .init(x: bounds.width - inset, y: y))
        
        y += gap
        let secondLine = LineModel(startPoint: .init(x: inset, y: y),
                                   endPoint: .init(x: bounds.width - inset, y: y))
        
        y += gap
        let thirdLine = LineModel(startPoint: .init(x: inset, y: y),
                                  endPoint: .init(x: bounds.width - inset, y: y))
        
        y += gap
        let fourthLine = LineModel(startPoint: .init(x: inset, y: y),
                                   endPoint: .init(x: bounds.width - inset, y: y))
        
        return ShapeModel(firstLine: firstLine,
                          secondLine: secondLine,
                          thirdLine: thirdLine,
                          fourthLine: fourthLine)
    }
    
    private var rightShapeModel: ShapeModel {

        var y: CGFloat = startY
        
        let firstLine = LineModel(startPoint: .init(x: inset, y: y),
                                  endPoint: .init(x: bounds.width - inset, y: y))
        
        y += gap
        let secondLine = LineModel(startPoint: .init(x: doubleInset, y: y),
                                   endPoint: .init(x: bounds.width - inset, y: y))
        
        y += gap
        let thirdLine = LineModel(startPoint: .init(x: inset, y: y),
                                  endPoint: .init(x: bounds.width - inset, y: y))
        
        y += gap
        let fourthLine = LineModel(startPoint: .init(x: doubleInset, y: y),
                                   endPoint: .init(x: bounds.width - inset, y: y))
        
        return ShapeModel(firstLine: firstLine,
                          secondLine: secondLine,
                          thirdLine: thirdLine,
                          fourthLine: fourthLine)
    }
    
    override func setup() {
        
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round

        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviewsChangedBounds() {

        shapeModel = fetchShapeModel()
    }

    fileprivate func fetchShapeModel() -> ShapeModel {
        switch aligment {
        case .left: return leftShapeModel
        case .center: return centerShapeModel
        case .right: return rightShapeModel
        }
    }

    override class var layerClass: AnyClass {
        
        AnimatableLayer.self
    }
    
    private var animatableLayer: AnimatableLayer {
        
        return layer as! AnimatableLayer
    }
    
    func apply(aligment: Aligment) {
        self.aligment = aligment
        shapeModel = fetchShapeModel()
    }
    
    func apply(model: Model) {
        aligment = model.aligment
        onTap = model.onTap
        shapeModel = fetchShapeModel()
    }

    private func toggleAligment() {
        switch aligment {
        case .left:
            aligment = .center
        case .center:
            aligment = .right
        case .right:
            aligment = .left
        }
        shapeModel = fetchShapeModel()
    }
    
    override func display(_ layer: CALayer) {
        guard let presentationLayer = layer.presentation() as? AnimatableLayer else {
            return
        }
        
        let shapeToRender = presentationLayer.shapeModel
        
        if let lastRenderedShape = lastRenderedShape,
           lastRenderedShape.firstLine.startPoint.distance(to: shapeToRender.firstLine.startPoint) > 2 {
            return
        }
        
        let path = makePath(shapeModel: shapeToRender)
        shapeLayer.path = path.cgPath
        lastRenderedShape = shapeToRender
    }

    private func makePath(shapeModel: ShapeModel) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        path.move(to: shapeModel.firstLine.startPoint)
        path.addLine(to: shapeModel.firstLine.endPoint)

        path.move(to: shapeModel.secondLine.startPoint)
        path.addLine(to: shapeModel.secondLine.endPoint)

        path.move(to: shapeModel.thirdLine.startPoint)
        path.addLine(to: shapeModel.thirdLine.endPoint)

        path.move(to: shapeModel.fourthLine.startPoint)
        path.addLine(to: shapeModel.fourthLine.endPoint)

        return path
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        toggleAligment()
        
        onTap?(aligment)
    }
}
 
fileprivate class AnimatableLayer: BaseLayer {

    @NSManaged var startPoint1: CGPoint
    @NSManaged var endPoint1: CGPoint
    @NSManaged var startPoint2: CGPoint
    @NSManaged var endPoint2: CGPoint
    @NSManaged var startPoint3: CGPoint
    @NSManaged var endPoint3: CGPoint
    @NSManaged var startPoint4: CGPoint
    @NSManaged var endPoint4: CGPoint

    var shapeModel: ShapeModel {
        ShapeModel(firstLine: .init(startPoint: startPoint1, endPoint: endPoint1),
                   secondLine: .init(startPoint: startPoint2, endPoint: endPoint2),
                   thirdLine: .init(startPoint: startPoint3, endPoint: endPoint3),
                   fourthLine: .init(startPoint: startPoint4, endPoint: endPoint4))
    }
    
    override var animationDuration: CGFloat {
        Preferences.shared.slowAnimations ? 1 : 0.2
    }
    
    override func setup(from layer: Any) {
        if let layer = layer as? AnimatableLayer {
            self.startPoint1 = layer.startPoint1
            self.endPoint1 = layer.endPoint1
            
            self.startPoint2 = layer.startPoint2
            self.endPoint2 = layer.endPoint2

            self.startPoint3 = layer.startPoint3
            self.endPoint3 = layer.endPoint3

            self.startPoint4 = layer.startPoint4
            self.endPoint4 = layer.endPoint4
        }
    }

    override class func isAnimationKeySupported(_ key: String) -> Bool {
        key == #keyPath(startPoint1) || key == #keyPath(endPoint1) ||
        key == #keyPath(startPoint2) || key == #keyPath(endPoint2) ||
        key == #keyPath(startPoint3) || key == #keyPath(endPoint3) ||
        key == #keyPath(startPoint4) || key == #keyPath(endPoint4)
    }
}

fileprivate struct ShapeModel {
    let firstLine: LineModel
    let secondLine: LineModel
    let thirdLine: LineModel
    let fourthLine: LineModel
}
