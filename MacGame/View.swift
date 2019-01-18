import AppKit
import SpriteKit

class View:NSWindow {
    private weak var skview:SKView!
    private weak var twinky:SKSpriteNode?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .black
        outlets()
    }
    
    private func outlets() {
        let skview = SKView()
        skview.translatesAutoresizingMaskIntoConstraints = false
        skview.ignoresSiblingOrder = true
        skview.showsPhysics = true
        contentView!.addSubview(skview)
        
        let scene = SceneView()
        scene.left = {
            self.twinky?.run(SKAction.move(by:CGVector(dx:-15, dy:0), duration:0.1))
        }
        scene.right = {
            self.twinky?.run(SKAction.move(by:CGVector(dx:15, dy:0), duration:0.1))
        }
        scene.up = {
            self.twinky?.run(SKAction.applyImpulse(CGVector(dx:0, dy:40), duration:0.05))
        }
        skview.presentScene(scene)
        
        let twinky = SKSpriteNode(imageNamed:"stand-right-0")
        twinky.physicsBody = SKPhysicsBody(circleOfRadius:20)
        twinky.physicsBody!.allowsRotation = false
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
        
        let node = SKNode()
        node.addChild(grass)
        node.addChild(ground)
        node.physicsBody = SKPhysicsBody(edgeLoopFrom:node.calculateAccumulatedFrame())
        node.position = CGPoint(x:node.calculateAccumulatedFrame().width / 2,
                                y:node.calculateAccumulatedFrame().height / 2)
        twinky.position = CGPoint(x:400, y:node.calculateAccumulatedFrame().height + 25)
        scene.addChild(node)
        
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
