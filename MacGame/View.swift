import AppKit
import SpriteKit

class View:NSWindow, SKPhysicsContactDelegate {
    private weak var skview:SKView!
    private weak var twinky:SKSpriteNode?
    private var jumpable = false
    
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
        skview.showsPhysics = true
        contentView!.addSubview(skview)
        
        let scene = SceneView()
        scene.physicsWorld.contactDelegate = self
        scene.left = {
            self.twinky?.physicsBody!.velocity.dx = -160

        }
        scene.right = {
            self.twinky?.physicsBody!.velocity.dx = 160
        }
        scene.up = {
            if self.jumpable {
                self.twinky?.physicsBody!.velocity.dy = 500
                self.jumpable = false
            }
        }
        skview.presentScene(scene)
        
        let twinky = SKSpriteNode(imageNamed:"stand-right-0")
        twinky.physicsBody = SKPhysicsBody(circleOfRadius:20)
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
}
