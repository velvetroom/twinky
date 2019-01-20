import Foundation
import SpriteKit

public class Area {
    public var tint = SKColor()
    public var cols = 200
    let tileSize = CGSize(width:32, height:32)
    
    public init() { }
    
    public func make() -> SKNode {
        let node = SKSpriteNode()
        
        
        
        
        
        
        
        node.size = CGSize(width:tileSize.width * CGFloat(cols), height:tileSize.height * 6)
        let block = SKNode()
        block.physicsBody = SKPhysicsBody(edgeLoopFrom:CGRect(x:0, y:0, width:32, height:192))
        block.physicsBody!.categoryBitMask = .floor
        let sprite = SKSpriteNode(imageNamed:"tile-0")
        sprite.size = tileSize
        sprite.color = tint
        sprite.colorBlendFactor = 1
        block.addChild(sprite)
        node.addChild(block)
        return node
    }
}
