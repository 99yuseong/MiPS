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
    
    private var showingNode = SKShapeNode().then {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 500))
        path.addLine(to: CGPoint(x: -200, y: 500))
        path.close()
        $0.path = path.cgPath
        $0.lineWidth = 0
        $0.position = CGPoint.zero
    }
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: 40, height: 40))
        self.name = "UserNode"
        addChild(centerNode)
        addChild(border)
        addChild(showingNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawHeadRotation(to rot: HeadRotation) {
        showingNode.fillColor = UIColor.init(hexCode: "FFFFFF", alpha: 0.05)
        showingNode.zRotation = CGFloat(rot.yaw.toRadians())
    }
    
    func hideHeadRotation() {
        showingNode.fillColor = .clear
    }
}
