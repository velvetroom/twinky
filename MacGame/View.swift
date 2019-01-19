import AppKit
import SpriteKit

class View:NSWindow, SKPhysicsContactDelegate {
    private weak var skview:SKView!
    private weak var twinky:SKSpriteNode?
    private var jumpable = false
    private let walk = SKAction.animate(with:[SKTexture(imageNamed:"twinky-walk-0"),
                                              SKTexture(imageNamed:"twinky-walk-1")], timePerFrame:0.2)
    private let stand = SKAction.sequence([SKAction.wait(forDuration:0.6),
                                           SKAction.setTexture(SKTexture(imageNamed:"twinky-stand"))])
    private let jump = SKAction.animate(with:[SKTexture(imageNamed:"twinky-jump-0"),
                                              SKTexture(imageNamed:"twinky-jump-1"),
                                              SKTexture(imageNamed:"twinky-stand")], timePerFrame:0.3)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .black
        outlets()
    }
    
    func didBegin(_ contact:SKPhysicsContact) {
        if contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == .twinky + .floor {
            jumpable = true
        }
    }
    
    private func outlets() {
        let skview = SKView()
        skview.translatesAutoresizingMaskIntoConstraints = false
        skview.ignoresSiblingOrder = true
        contentView!.addSubview(skview)
        self.skview = skview
        
        let scene = SceneView()
        scene.physicsWorld.contactDelegate = self
        scene.left = { if let twinky = self.twinky { self.sides(twinky, scale:-1) } }
        scene.right = { if let twinky = self.twinky { self.sides(twinky, scale:1) } }
        scene.up = { if let twinky = self.twinky { self.up(twinky) } }
        scene.space = { self.skview.isPaused.toggle() }
        skview.presentScene(scene)
        
        let twinky = SKSpriteNode(imageNamed:"twinky-stand")
        twinky.physicsBody = SKPhysicsBody(circleOfRadius:18)
        twinky.physicsBody!.allowsRotation = false
        twinky.physicsBody!.categoryBitMask = .twinky
        twinky.physicsBody!.contactTestBitMask = .floor
        scene.addChild(twinky)
        self.twinky = twinky
        
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
        
        let floor = SKNode()
        floor.addChild(grass)
        floor.addChild(ground)
        let floorSize = floor.calculateAccumulatedFrame()
        floor.physicsBody = SKPhysicsBody(edgeLoopFrom:floorSize)
        floor.physicsBody!.categoryBitMask = .floor
        floor.position = CGPoint(x:floorSize.width / 2, y:floorSize.height / 2)
        twinky.position = CGPoint(x:400, y:floorSize.height + 25)
        scene.addChild(floor)
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x:400, y:300)
        scene.addChild(camera)
        camera.constraints = [
            SKConstraint.distance(SKRange(upperLimit:200), to:twinky),
        SKConstraint.positionX(SKRange(lowerLimit:400, upperLimit:10000), y:SKRange(constantValue:300))]
        scene.camera = camera
        
        skview.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        skview.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        skview.widthAnchor.constraint(equalToConstant:800).isActive = true
        skview.heightAnchor.constraint(equalToConstant:600).isActive = true
    }
    
    private func sides(_ twinky:SKNode, scale:CGFloat) {
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
    
    private func up(_ twinky:SKNode) {
        if jumpable {
            jumpable = false
            twinky.removeAllActions()
            twinky.physicsBody!.velocity.dy = 600
            twinky.run(jump, withKey:"jump")
        }
    }
}
