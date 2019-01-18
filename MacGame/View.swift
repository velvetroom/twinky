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
            print("left")
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
        twinky.position = CGPoint(x:contentView!.bounds.midX, y:contentView!.bounds.midY)
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
        let grass = SKTileMapNode(tileSet:SKTileSet(tileGroups:[grassGroup]), columns:50, rows:5, tileSize:
            CGSize(width:16, height:16), fillWith:grassGroup)
        let ground = SKTileMapNode(tileSet:SKTileSet(tileGroups:[groundGroup]), columns:50, rows:1, tileSize:
            CGSize(width:16, height:16), fillWith:groundGroup)
        ground.position = CGPoint(x:0, y:grass.mapSize.height / 2)
        
        let node = SKNode()
        node.addChild(grass)
        node.addChild(ground)
        node.physicsBody = SKPhysicsBody(edgeLoopFrom:node.calculateAccumulatedFrame())
        node.position = CGPoint(x:node.calculateAccumulatedFrame().width / 2,
                                y:node.calculateAccumulatedFrame().height / 2)
        scene.addChild(node)
        
        skview.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        skview.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        skview.widthAnchor.constraint(equalToConstant:800).isActive = true
        skview.heightAnchor.constraint(equalToConstant:600).isActive = true
    }
}
