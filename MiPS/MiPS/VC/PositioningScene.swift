//
//  PositioningScene.swift
//  MiPS
//
//  Created by 남유성 on 12/19/23.
//

import SpriteKit
import Then

protocol PositioningSceneDelegate: NSObjectProtocol {
    func startPositioning()
    func resetPositioning()
//    func endPositioning()
}

class PositioningScene: SKScene {
    
    weak var positioningDelegate: PositioningSceneDelegate?
    
    private var userNode = UserNode()
    
    private var infoNode = SKLabelNode().then {
        $0.text = "Drag and Position Instruments"
        $0.fontName = Montserrat.regular.rawValue
        $0.fontSize = 16
        $0.fontColor = SKColor.white
        $0.horizontalAlignmentMode = .center
        $0.verticalAlignmentMode = .center
    }
    
    private lazy var lineNode = SKShapeNode().then {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: 80))
        path.addLine(to: CGPoint(x: self.frame.maxX - 20, y: 80))

        $0.strokeColor = UIColor.white
        $0.path = path.cgPath
        $0.lineWidth = 0.1
    }
    
    var selectedNode: InstrumentNode?
    
    private var exceptNodes: [InstrumentNode] = []
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        enumerateChildNodes(withName: "InstrumentNode") { node, _ in
            if let instrNode = node as? InstrumentNode, instrNode.frame.contains(location) {
                self.selectedNode = instrNode
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let node = selectedNode
        else { return }
        
        let location = touch.location(in: self)
        node.position = location
        
        if let index = exceptNodes.firstIndex(of: node) {
            if node.position.y < 150 || node.position.y > 720 {
                exceptNodes.remove(at: index)
                node.reset()
                rearrangeInstrumentNodes()
                selectedNode = nil
            } else {
                node.addSectionCircle(at: location, from: CGPoint(x: frame.midX, y: frame.midY), true)
            }
        } else {
            if node.position.y >= 150 && node.position.y <= 720 {
                exceptNodes.append(node)
                rearrangeInstrumentNodes()
                node.addSectionCircle(at: location, from: CGPoint(x: frame.midX, y: frame.midY), true)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
              
        if exceptNodes.count == 1 {
            positioningDelegate?.startPositioning()
        }
        
        if exceptNodes.count == 0 {
            positioningDelegate?.resetPositioning()
        }
        
        if exceptNodes.count == 6 {
            moveInfoNode(isUp: false)
        } else {
            moveInfoNode(isUp: true)
        }
    
        guard let node = selectedNode else { return }
        
        let location = touch.location(in: self)
        
        node.addSectionCircle(at: location, from: CGPoint(x: frame.midX, y: frame.midY))
        rearrangeInstrumentNodes()
        selectedNode = nil
    }
}

extension PositioningScene {
    func setUp() {
        addUserNode()
        addInfoNode()
    }
    
    func addUserNode() {
        userNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(userNode)
    }
    
    func addInfoNode() {
        infoNode.position = CGPoint(x: frame.midX, y: 100)
        addChild(infoNode)
        addChild(lineNode)
    }
    
    func addInstrumentNodes(_ instruments: [Instruments]) {
        let padding: CGFloat = 20
        let nodeCount = instruments.count
        
        let totalNodeWidth = CGFloat(nodeCount) * InstrumentNode.size
        let remainingWidth = size.width - totalNodeWidth - 2 * padding
        let spacing = remainingWidth / CGFloat(nodeCount - 1)
        
        for (i, type) in instruments.enumerated() {
            let node = InstrumentNode(type: type)
            let xPosition = padding + InstrumentNode.size / 2 + CGFloat(i) * (InstrumentNode.size + spacing)
            let yPosition = 30 + InstrumentNode.size / 2
            node.position = CGPoint(x: xPosition, y: yPosition)
            addChild(node)
        }
    }
    
    func rearrangeInstrumentNodes() {
        let padding: CGFloat = 20
        let nodesToArrange = children.filter { node in
            guard let instrumentNode = node as? InstrumentNode else { return false }
            return !exceptNodes.contains(instrumentNode)
        }
        let nodeCount = 6
        
        let totalNodeWidth = CGFloat(nodeCount) * InstrumentNode.size
        let remainingWidth = size.width - totalNodeWidth - 2 * padding
        let spacing = remainingWidth / CGFloat(nodeCount - 1)
        
        for (i, node) in nodesToArrange.enumerated() {
            let xPosition = padding + InstrumentNode.size / 2 + CGFloat(i) * (InstrumentNode.size + spacing)
            let yPosition = 30 + InstrumentNode.size / 2
            let newPosition = CGPoint(x: xPosition, y: yPosition)
            
            let moveAction = SKAction.move(to: newPosition, duration: 0.3)
            node.run(moveAction)
        }
    }
    
    func moveInfoNode(isUp: Bool) {
        var yPos: CGFloat
        
        if lineNode.frame.midY >= 79 {
            yPos = isUp ? 0 : -60
        } else {
            yPos = isUp ? 60 : 0
        }
        
        if !isUp {
            infoNode.text = "Tap Play Buttons"
        } else {
            infoNode.text = "Drag and Position Instruments"
        }
        
        let moveAction = SKAction.moveBy(
            x: 0,
            y: yPos,
            duration: 0.2
        )
        infoNode.run(moveAction)
        lineNode.run(moveAction)
    }
    
    func resetAll() {
        resetNodes()
        resetInfoNodes()
    }
    
    func resetNodes() {
        exceptNodes = []
        rearrangeInstrumentNodes()
        for node in children {
            if let node = node as? InstrumentNode {
                node.reset()
            }
        }
    }
    
    func resetInfoNodes() {
        infoNode.position = CGPoint(x: frame.midX, y: 100)
        lineNode.position = CGPoint(x: 0, y: 0)
    }
}
