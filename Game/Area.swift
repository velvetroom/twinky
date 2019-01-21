import Foundation
import SpriteKit

public class Area {
    public var cols = 500
    public var rows = 3
    public var gap = 4
    private(set) var plan = [Int]()
    let size = CGSize(width:32, height:32)
    
    public init() { }
    
    public func make() -> SKNode {
        makePlan()
        let node = SKNode()
        node.zPosition = -1
        var origin:CGPoint? = CGPoint(x:0, y:size.height * CGFloat(rows) - 8)
        plan.enumerated().forEach {
            if $0.element == 1 {
                for y in 0 ..< rows {
                    let name:String
                    var scale = CGFloat(1)
                    if $0.offset > 0 && plan[$0.offset - 1] == 0 || $0.offset < cols - 1 && plan[$0.offset + 1] == 0 {
                        name = y == rows - 1 ? "grass-border" : "ground-border"
                        scale = plan[$0.offset - 1] == 0 ? 1 : -1
                    } else {
                        name = "\(y == rows - 1 ? "grass" : "ground" )-\(Int.random(in:0 ... 9))"
                    }
                    let tile = SKSpriteNode(imageNamed:name)
                    tile.size = size
                    tile.xScale = scale
                    tile.position = CGPoint(x:CGFloat($0.offset) * size.width + (size.width / 2),
                                            y:CGFloat(y) * size.height + (size.height / 2))
                    node.addChild(tile)
                }
                if origin == nil {
                    origin = CGPoint(x:size.width * CGFloat($0.offset), y:size.height * CGFloat(rows) - 8)
                }
            } else if origin != nil || $0.offset == cols - 1 {
                let edge = SKNode()
                edge.physicsBody = SKPhysicsBody(edgeFrom:origin!, to:
                    CGPoint(x:size.width * CGFloat($0.offset), y:origin!.y))
                edge.physicsBody!.categoryBitMask = .floor
                node.addChild(edge)
                origin = nil
            }
        }
        return node
    }
    
    func makePlan() {
        var gap = 0
        for x in 0 ..< cols {
            var col = 1
            if gap < self.gap && x > 20 && x < cols - 30 {
                if gap == 1 || .random(in:0 ..< 15) == 0 {
                    col = 0
                    gap += 1
                } else {
                    gap = 0
                }
            } else {
                gap = 0
            }
            plan.append(col)
        }
    }
}
