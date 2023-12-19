//
//  UserNode.swift
//  MiPS
//
//  Created by 남유성 on 12/19/23.
//

import SpriteKit
import Then

class UserNode: SKSpriteNode {
    private lazy var centerNode = SKShapeNode(circleOfRadius: 9).then {
        $0.fillColor = .white
    }
    
    private var border = SKShapeNode(circleOfRadius: 20).then {
        $0.strokeColor = UIColor.white
        $0.lineWidth = 0.5
    }
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: 40, height: 40))
        self.name = "UserNode"
        addChild(centerNode)
        addChild(border)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
