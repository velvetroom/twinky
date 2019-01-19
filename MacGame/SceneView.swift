import SpriteKit

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
        backgroundColor = .blue
        scaleMode = .resizeFill
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
        
    }
    
    private func outlets() {
        let twinky = SKSpriteNode(imageNamed:"twinky-stand")
        twinky.physicsBody = SKPhysicsBody(circleOfRadius:18)
        twinky.physicsBody!.allowsRotation = false
        twinky.physicsBody!.categoryBitMask = .twinky
        twinky.physicsBody!.contactTestBitMask = .floor
        addChild(twinky)
        self.twinky = twinky
        /*
         var grassTiles = [SKTileDefinition]()
         var groundTiles = [SKTileDefinition]()
         for x in 0 ... 4 {
         grassTiles.append(SKTileDefinition(texture:SKTexture(imageNamed:"grass-\(x)")))
         for y in 0 ... 2 {
         groundTiles.append(SKTileDefinition(texture:SKTexture(imageNamed:"grass-\(x)-top-\(y)")))
         }
         }
         
         let grassGroup = SKTileGroup(rules:[SKTileGroupRule(adjacency:[], tileDefinitions:grassTiles)])
         let groundGroup = SKTileGroup(rules:[SKTileGroupRule(adjacency:[], tileDefinitions:groundTiles)])
         let grass = SKTileMapNode(tileSet:SKTileSet(tileGroups:[grassGroup]), columns:100, rows:5, tileSize:
         CGSize(width:16, height:16), fillWith:grassGroup)
         let ground = SKTileMapNode(tileSet:SKTileSet(tileGroups:[groundGroup]), columns:100, rows:1, tileSize:
         CGSize(width:16, height:16), fillWith:groundGroup)
         ground.position = CGPoint(x:0, y:grass.mapSize.height / 2)
         ground.color = NSColor.red
         ground.blendMode = .add
         ground.colorBlendFactor = 1
         */
        let floor = SKNode()
        //        floor.addChild(grass)
        //        floor.addChild(ground)
        let floorSize = floor.calculateAccumulatedFrame()
        floor.physicsBody = SKPhysicsBody(edgeLoopFrom:floorSize)
        floor.physicsBody!.categoryBitMask = .floor
        floor.position = CGPoint(x:floorSize.width / 2, y:floorSize.height / 2)
        twinky.position = CGPoint(x:400, y:floorSize.height + 25)
        addChild(floor)
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x:400, y:300)
        addChild(camera)
        camera.constraints = [
            SKConstraint.distance(SKRange(upperLimit:200), to:twinky),
            SKConstraint.positionX(SKRange(lowerLimit:400, upperLimit:10000), y:SKRange(constantValue:300))]
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
        twinky.physicsBody!.velocity.dx = 160 * scale
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
            twinky.physicsBody!.velocity.dy = 600
            twinky.run(jump, withKey:"jump")
        }
    }
}
