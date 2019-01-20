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
        let path = CGMutablePath()
        path.move(to:CGPoint(x:0, y:-100))
        plan.enumerated().forEach {
            path.addLine(to:CGPoint(x:size.width * CGFloat($0.offset), y:path.currentPoint.y))
            if $0.element == 1 {
                for y in 0 ..< rows {
                    let tile = SKSpriteNode(imageNamed:"ground-\(Int.random(in:0 ... 9))")
                    tile.size = size
                    tile.position = CGPoint(x:CGFloat($0.offset) * size.width + (size.width / 2),
                                            y:CGFloat(y) * size.height + (size.height / 2))
                    node.addChild(tile)
                }
                path.addLine(to:CGPoint(x:path.currentPoint.x, y:size.height * CGFloat(rows)))
            } else {
                path.addLine(to:CGPoint(x:path.currentPoint.x, y:-100))
            }
        }
        path.addLine(to:CGPoint(x:size.width * CGFloat(cols), y:-100))
        path.closeSubpath()
        node.physicsBody = SKPhysicsBody(edgeLoopFrom:path)
        node.physicsBody!.categoryBitMask = .floor
        node.zPosition = -1
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
