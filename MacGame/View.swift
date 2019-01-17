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
        contentView!.addSubview(skview)
        
        let scene = SKScene()
        scene.backgroundColor = .clear
        scene.scaleMode = .resizeFill
        skview.presentScene(scene)
        
        let twinky = SKSpriteNode(imageNamed:"stand-right-0")
        twinky.position = CGPoint(x:contentView!.bounds.midX, y:contentView!.bounds.midY)
        scene.addChild(twinky)
        
        let group = SKTileGroup(rules:[SKTileGroupRule(adjacency:.adjacencyAll, tileDefinitions:[
                SKTileDefinition(texture:SKTexture(imageNamed:"grass-0")),
                SKTileDefinition(texture:SKTexture(imageNamed:"grass-1")),
                SKTileDefinition(texture:SKTexture(imageNamed:"grass-2")),
                SKTileDefinition(texture:SKTexture(imageNamed:"grass-3"))])])
        let floor = SKTileMapNode(tileSet:SKTileSet(tileGroups:[group]), columns:50, rows:5, tileSize:
            CGSize(width:16, height:16), fillWith:group)
        floor.position = CGPoint(x:floor.mapSize.width / 2, y:floor.mapSize.height / 2)
        scene.addChild(floor)
        
        skview.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        skview.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        skview.widthAnchor.constraint(equalToConstant:800).isActive = true
        skview.heightAnchor.constraint(equalToConstant:600).isActive = true
    }
}
