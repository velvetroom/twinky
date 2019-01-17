import AppKit
import SpriteKit

class View:NSWindow {
    private weak var skview:SKView!
    
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
        
        let scene = SKScene()
        scene.backgroundColor = .clear
        scene.scaleMode = .resizeFill
        skview.presentScene(scene)
        
        let twinky = SKSpriteNode(imageNamed:"stand-right-0")
        twinky.position = CGPoint(x:contentView!.bounds.midX, y:contentView!.bounds.midY)
        scene.addChild(twinky)
        twinky.physicsBody = SKPhysicsBody(texture:twinky.texture!, size:twinky.texture!.size())
        twinky.physicsBody?.isDynamic = false
        
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
        grass.position = CGPoint(x:grass.mapSize.width / 2, y:grass.mapSize.height / 2)
        let ground = SKTileMapNode(tileSet:SKTileSet(tileGroups:[groundGroup]), columns:50, rows:1, tileSize:
            CGSize(width:16, height:16), fillWith:groundGroup)
        ground.position = CGPoint(x:ground.mapSize.width / 2, y:(ground.mapSize.height / 2) + grass.mapSize.height)
        scene.addChild(grass)
        scene.addChild(ground)
        
        skview.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        skview.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        skview.widthAnchor.constraint(equalToConstant:800).isActive = true
        skview.heightAnchor.constraint(equalToConstant:600).isActive = true
    }
}
