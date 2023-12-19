//
//  PositioningScene.swift
//  MiPS
//
//  Created by 남유성 on 12/19/23.
//

import SpriteKit

class PositioningScene: SKScene {
    
    let nodeSize: CGFloat = 36
    let nodeCount: Int = 6
    let padding: CGFloat = 20
    
    var selectedNode: InstrumentNode?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    func drawInstrumentNode() {
        let totalNodeWidth = CGFloat(nodeCount) * nodeSize
        let remainingWidth = size.width - totalNodeWidth - 2 * padding
        let spacing = remainingWidth / CGFloat(nodeCount - 1)
        
        for (i, type) in Instruments.allCases.enumerated() {
            let node = InstrumentNode(type: type)
            let xPosition = padding + nodeSize / 2 + CGFloat(i) * (nodeSize + spacing)
            let yPosition = 30 + nodeSize / 2
            node.position = CGPoint(x: xPosition, y: yPosition)
            addChild(node)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        enumerateChildNodes(withName: "InstrumentNode") { node, _ in
            if let instrumentNode = node as? InstrumentNode, instrumentNode.frame.contains(location) {
                self.selectedNode = instrumentNode
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first, let node = selectedNode else { return }
        let location = touch.location(in: self)
        node.position = location
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode = nil
    }
}
