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
