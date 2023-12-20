//
//  InstrumentNode.swift
//  MiPS
//
//  Created by 남유성 on 12/18/23.
//

import SpriteKit
import Then

class InstrumentNode: SKSpriteNode {
    
    static let size: CGFloat = 36
    let type: Instruments

    private lazy var typeLabel = SKLabelNode().then {
        $0.text = self.type.rawValue
        $0.fontName = Montserrat.semiBold.rawValue
        $0.fontSize = 18
        $0.fontColor = SKColor.white
        $0.horizontalAlignmentMode = .center
        $0.verticalAlignmentMode = .center
        $0.position = CGPoint.zero
    }
    
    private lazy var border = SKShapeNode(circleOfRadius: 18).then {
        $0.strokeColor = SKColor.white
        $0.lineWidth = 0.5
        $0.position = CGPoint.zero
    }
    
    private var aroundCircle = SKShapeNode(circleOfRadius: 0).then {
        $0.strokeColor = SKColor.init(hexCode: "555555", alpha: 0.5)
        $0.lineWidth = 0.5
        $0.position = CGPoint.zero
        $0.zPosition = -1
    }
    
    init(type: Instruments) {
        self.type = type
        super.init(texture: nil, color: .clear, size: CGSize(width: InstrumentNode.size, height: InstrumentNode.size))
        
        self.name = "InstrumentNode"
        
        addChild(typeLabel)
        addChild(border)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InstrumentNode {
    func addSectionCircle(at location: CGPoint, from center: CGPoint, _ isActive: Bool = false) {
        aroundCircle.removeFromParent()
        
        aroundCircle.strokeColor = isActive ? SKColor.white.withAlphaComponent(0.8) : SKColor.init(hexCode: "555555", alpha: 0.8)
        
        let radius = distBtwPoints(location, center)
        aroundCircle.path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        addChild(aroundCircle)
    }
    
    func reset() {
        aroundCircle.removeFromParent()
    }
    
    func distBtwPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let xDist = point2.x - point1.x
        let yDist = point2.y - point1.y
        
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
    
    func changeColor(to color: SKColor) {
        aroundCircle.lineWidth = 0
        aroundCircle.fillColor = color
    }
    
    func resetColor() {
        aroundCircle.lineWidth = 0.5
        aroundCircle.fillColor = .clear
    }
}
