import SpriteKit
import Game

class SceneView:SKScene, SKPhysicsContactDelegate {
    private weak var twinky:SKSpriteNode!
    private var jumpable = false
    private var time = TimeInterval()
    private var arrowLeft = false
    private var arrowRight = false
    private var arrowUp = false
    private let walk = SKAction.animate(with:[SKTexture(imageNamed:"twinky-walk-0"),
                                              SKTexture(imageNamed:"twinky-walk-1")], timePerFrame:0.2)
    private let stand = SKAction.sequence([SKAction.wait(forDuration:0.6),
                                           SKAction.setTexture(SKTexture(imageNamed:"twinky-stand"))])
    private let jump = SKAction.animate(with:[SKTexture(imageNamed:"twinky-jump-0"),
                                              SKTexture(imageNamed:"twinky-jump-1"),
                                              SKTexture(imageNamed:"twinky-stand")], timePerFrame:0.3)
    
    override func didMove(to view:SKView) {
        super.didMove(to:view)
        backgroundColor = .clear
        scaleMode = .resizeFill
        physicsWorld.contactDelegate = self
        area()
        outlets()
    }
    
    override func update(_ time:TimeInterval) {
        super.update(time)
        if time - self.time > 0.05 {
            if arrowLeft { sides(-1) }
            if arrowRight { sides(1) }
            if arrowUp { up() }
            self.time = time
        }
    }
    
    func didBegin(_ contact:SKPhysicsContact) {
        if contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == .twinky + .floor {
            jumpable = true
        }
    }
    
    override func keyDown(with event:NSEvent) { key(event.keyCode, modifier:true) }
    override func keyUp(with event:NSEvent) { key(event.keyCode, modifier:false) }
    
    private func area() {
        addChild(Area().make())
    }
    
    private func outlets() {
        let sky = SKSpriteNode(imageNamed:"sky")
        sky.zPosition = -2
        
        let twinky = SKSpriteNode(imageNamed:"twinky-stand")
        twinky.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width:24, height:36))
        twinky.physicsBody!.allowsRotation = false
        twinky.physicsBody!.categoryBitMask = .twinky
        twinky.physicsBody!.contactTestBitMask = .floor
        twinky.position = CGPoint(x:400, y:120)
        addChild(twinky)
        self.twinky = twinky
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x:400, y:300)
        camera.addChild(sky)
        addChild(camera)
        camera.constraints = [
            SKConstraint.distance(SKRange(upperLimit:200), to:twinky),
            SKConstraint.positionX(SKRange(lowerLimit:400, upperLimit:100000), y:SKRange(constantValue:300))]
        self.camera = camera
    }
    
    private func key(_ code:uint16, modifier:Bool) {
        switch code {
        case 123: arrowLeft = modifier
        case 124: arrowRight = modifier
        case 126: arrowUp = modifier
        case 49: if modifier { isPaused.toggle() }
        default: break
        }
    }
    
    private func sides(_ scale:CGFloat) {
        twinky.xScale = scale
        twinky.physicsBody!.velocity.dx = 170 * scale
        if jumpable {
            if twinky.action(forKey:"walk") == nil {
                twinky.run(walk, withKey:"walk")
            }
            twinky.removeAction(forKey:"stand")
            twinky.run(stand, withKey:"stand")
        }
    }
    
    private func up() {
        if jumpable {
            jumpable = false
            twinky.removeAllActions()
            twinky.physicsBody!.velocity.dy = 650
            twinky.run(jump, withKey:"jump")
        }
    }
}
