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
}

class PositioningScene: SKScene {
    
    var selectedNode: InstrumentNode?
    private var exceptNodes: [InstrumentNode] = []
    private var spotlightColors: [SKColor] = [
        SKColor.init(hexCode: "FF6EC7", alpha: 0.2),
        SKColor.init(hexCode: "FF073A", alpha: 0.2),
        SKColor.init(hexCode: "FFFF00", alpha: 0.2),
        SKColor.init(hexCode: "39FF14", alpha: 0.2),
        SKColor.init(hexCode: "4D4DFF", alpha: 0.2),
        SKColor.init(hexCode: "9400D3", alpha: 0.2)
    ]
    
    weak var positioningDelegate: PositioningSceneDelegate?
    
    // MARK: - UI
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
    
    private lazy var backgroundNode = SKSpriteNode().then {
        $0.color = UIColor.init(hexCode: "1c1c1c")
        $0.position = CGPoint(x: frame.midX, y: frame.midY)
        $0.zPosition = -1
    }
    
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
            } else {
                node.reset()
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
        if node.position.y >= 150 && node.position.y <= 720 {
            node.position = location
            node.addSectionCircle(at: location, from: CGPoint(x: frame.midX, y: frame.midY))
        }
        rearrangeInstrumentNodes()
        selectedNode = nil
    }
}

extension PositioningScene {
    func setUp() {
        addBgNode()
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
    
    func addBgNode() {
        backgroundNode.size = size
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(backgroundNode)
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
        resetBgColor()
    }
    
    func resetNodes() {
        exceptNodes = []
        rearrangeInstrumentNodes()
        for node in children {
            if let node = node as? InstrumentNode {
                node.reset()
                node.resetColor()
            }
        }
    }
    
    func resetInfoNodes() {
        infoNode.position = CGPoint(x: frame.midX, y: 100)
        infoNode.text = "Drag and Position Instruments"
        lineNode.position = CGPoint(x: 0, y: 0)
    }
    
    func resetBgColor() {
        changeBgColor(to: UIColor.init(hexCode: "1c1c1c"))
    }
    
    func changeBgColor(to color: UIColor) {
        let colorAction = SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.5)
        backgroundNode.run(colorAction)
    }
}

extension PositioningScene {
    func isMusicAvailable() -> Bool {
        return exceptNodes.count == 6
    }
    
    func playMusic() {
        for (i, exceptNode) in self.exceptNodes.enumerated() {
            exceptNode.changeColor(to: spotlightColors[i])
        }
        changeBgColor(to: UIColor.init(hexCode: "000000"))
    }
    
    func pauseMusic() {
        for exceptNode in self.exceptNodes {
            exceptNode.resetColor()
        }
        changeBgColor(to: UIColor.init(hexCode: "1c1c1c"))
    }
}

extension PositioningScene {
    func drawHeadRotation(to rot: HeadRotation) {
        userNode.drawHeadRotation(to: rot)
    }
    
    func hideHeadRotation() {
        userNode.hideHeadRotation()
    }
    
    func calSoundSources() -> [SoundSource] {
        exceptNodes.map { relativePosition(of: $0).calSoundSource(of: $0.type) }
    }
    
    func relativePosition(of node: SKNode) -> CGPoint {
        let centerA = CGPoint(x: userNode.frame.midX, y: userNode.frame.midY)
        let centerB = CGPoint(x: node.frame.midX, y: node.frame.midY)

        return CGPoint(x: centerB.x - centerA.x, y: centerB.y - centerA.y)
    }
}
