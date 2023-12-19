//
//  PositioningScene.swift
//  MiPS
//
//  Created by 남유성 on 12/19/23.
//

import SpriteKit

class PositioningScene: SKScene {
    
    var selectedNode: InstrumentNode?
    
    private var exceptNodes: [InstrumentNode] = []
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    func initializeInstrumentNodes() {
        
    }
    
    func drawInstrumentNode(_ instruments: [Instruments]) {
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
    
    func resetNodes() {
        exceptNodes = []
        rearrangeNodes()
    }
    
    func rearrangeNodes() {
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
        
        node.position = touch.location(in: self)
        
        if let index = exceptNodes.firstIndex(of: node) {
            if node.position.y < 150 || node.position.y > 720 {
                exceptNodes.remove(at: index)
                rearrangeNodes()
                selectedNode = nil
            }
        } else {
            if node.position.y >= 150 && node.position.y <= 720 {
                exceptNodes.append(node)
                rearrangeNodes()
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = selectedNode else { return }
        
//        if let index = exceptNodes.firstIndex(of: node) {
//            if node.position.y < 150 || node.position.y > 700 {
//                exceptNodes.remove(at: index)
//            }
//        }
        
        rearrangeNodes()
        selectedNode = nil
    }
}
