//
//  GameScene.swift
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//
import SpriteKit

class GameScene: SKScene {
    
    var appleNode: SKSpriteNode?
	let moveJoystick = 🕹(withDiameter: 100)
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

		let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
		moveJoystickHiddenArea.joystick = moveJoystick
		addChild(moveJoystickHiddenArea)
		
        //MARK: Handlers begin
		moveJoystick.on(.begin) { [unowned self] _ in
			let actions = [
				SKAction.scale(to: 0.5, duration: 0.5),
				SKAction.scale(to: 1, duration: 0.5)
			]

			self.appleNode?.run(SKAction.sequence(actions))
		}
		
		moveJoystick.on(.move) { [unowned self] joystick in
			guard let appleNode = self.appleNode else {
				return
			}
			
			let pVelocity = joystick.velocity;
			let speed = CGFloat(0.12)
			
			appleNode.position = CGPoint(x: appleNode.position.x + (pVelocity.x * speed), y: appleNode.position.y + (pVelocity.y * speed))
		}
		
		moveJoystick.on(.end) { [unowned self] _ in
			let actions = [
				SKAction.scale(to: 1.5, duration: 0.5),
				SKAction.scale(to: 1, duration: 0.5)
			]

			self.appleNode?.run(SKAction.sequence(actions))
		}
		
        //MARK: Handlers end
        addApple(CGPoint(x: frame.midX, y: frame.midY))

        view.isMultipleTouchEnabled = true
    }
    
    func addApple(_ position: CGPoint) {
        guard let appleImage = UIImage(named: "apple") else {
            return
        }
        
        let texture = SKTexture(image: appleImage)
        let apple = SKSpriteNode(texture: texture)
        apple.physicsBody = SKPhysicsBody(texture: texture, size: apple.size)
        apple.physicsBody!.affectedByGravity = false
        apple.position = position
        addChild(apple)
        appleNode = apple
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
