//
//  CancelBackView.swift
//  TelegramInspiredAnimatableButtons
//
//  Created by Sergey Zapuhlyak on 15.10.2022.
//

import UIKit

final class CancelBackView: BaseView {
    
    enum State {
        case cancel
        case back
    }
    
    struct Model {
        let state: State
        let onTap: ((State) -> Void)? = nil
    }
    
    fileprivate var shapeModel: ShapeModel {
        set {
            animatableLayer.startPoint1 = newValue.firstLine.startPoint
            animatableLayer.endPoint1 = newValue.firstLine.endPoint
            animatableLayer.startPoint2 = newValue.secondLine.startPoint
            animatableLayer.endPoint2 = newValue.secondLine.endPoint
        }
        get {
            animatableLayer.shapeModel
        }
    }

    private var shapeLayer = CAShapeLayer()

    private var lineWidth: CGFloat = 2.0
    
    private var state: State = .cancel
    
    private var onTap: ((State) -> Void)? = nil

    private var lastRenderedShape: ShapeModel?
    
    private var cancelShapeModel: ShapeModel {
        let radius = bounds.height / 2
        let value = lineWidth * 3
        let firstLine = LineModel(startPoint: CGPoint(x: radius - value, y: radius + value),
                                  endPoint: CGPoint(x: radius + value, y: radius - value))
        
        let secondLine = LineModel(startPoint: CGPoint(x: radius - value, y: radius - value),
                                   endPoint: CGPoint(x: radius + value, y: radius + value))
        return ShapeModel(firstLine: firstLine, secondLine: secondLine)
    }
    
    private var backShapeModel: ShapeModel {
        let radius = bounds.height / 2
        let startX = radius - 2 * lineWidth
        let endX = radius - lineWidth + 4
        
        let firstLine = LineModel(startPoint: CGPoint(x: startX, y: radius),
                                  endPoint: CGPoint(x: endX, y: radius - 6))
        
        let secondLine = LineModel(startPoint: CGPoint(x: startX, y: radius),
                                   endPoint: CGPoint(x: endX, y: radius + 6))
        return ShapeModel(firstLine: firstLine, secondLine: secondLine)
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
        switch state {
        case .cancel: return cancelShapeModel
        case .back: return backShapeModel
        }
    }

    override class var layerClass: AnyClass {
        
        AnimatableLayer.self
    }
    
    private var animatableLayer: AnimatableLayer {
        
        return layer as! AnimatableLayer
    }
    
    func apply(model: Model) {
        state = model.state
        onTap = model.onTap
    }

    private func toggleState() {
        state = state == .cancel ? .back : .cancel
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
        
        let radius = bounds.height / 2
        
        let path = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: radius, y: radius),
                    radius: radius,
                    startAngle: 0.radians,
                    endAngle: 360.radians,
                    clockwise: true)

        path.move(to: shapeModel.firstLine.startPoint)
        path.addLine(to: shapeModel.firstLine.endPoint)

        path.move(to: shapeModel.secondLine.startPoint)
        path.addLine(to: shapeModel.secondLine.endPoint)

        return path
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        toggleState()
        
        onTap?(state)
    }
}
 
fileprivate class AnimatableLayer: BaseLayer {

    @NSManaged var startPoint1: CGPoint
    @NSManaged var endPoint1: CGPoint
    @NSManaged var startPoint2: CGPoint
    @NSManaged var endPoint2: CGPoint
    
    var shapeModel: ShapeModel {
        ShapeModel(firstLine: .init(startPoint: startPoint1, endPoint: endPoint1),
                   secondLine: .init(startPoint: startPoint2, endPoint: endPoint2))
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
        }
    }

    override class func isAnimationKeySupported(_ key: String) -> Bool {
        key == #keyPath(startPoint1) || key == #keyPath(endPoint1) ||
        key == #keyPath(startPoint2) || key == #keyPath(endPoint2)
    }
}

fileprivate struct ShapeModel {
    let firstLine: LineModel
    let secondLine: LineModel
}
