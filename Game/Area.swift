import Foundation
import SpriteKit

public class Area {
    public var cols = 500
    public var rows = 3
    public var gap = 4
    private(set) var floor = [Bool]()
    private(set) var nodes = [Node]()
    let size = CGSize(width:32, height:32)
    
    public init() { }
    
    public func make() -> SKNode {
        build()
        let node = SKNode()
        node.zPosition = -1
        renderFloor(node)
        renderNodes(node)
        return node
    }
    
    func build() {
        var gap = 0
        for x in 0 ..< cols {
            var col = true
            if gap < self.gap && x > 20 && x < cols - 30 {
                if gap == 1 || .random(in:0 ..< 15) == 0 {
                    col = false
                    gap += 1
                } else {
                    gap = 0
                }
            } else {
                gap = 0
            }
            var node = Node.none
            switch Int.random(in:0 ..< 6) {
            case 0: node = .block
            default:break
            }
            nodes.append(node)
            floor.append(col)
        }
    }
    
    private func renderFloor(_ node:SKNode) {
        var origin:CGPoint? = CGPoint(x:0, y:size.height * CGFloat(rows) - 5)
        floor.enumerated().forEach {
            if $0.element {
                for y in 0 ..< rows {
                    let name:String
                    var scale = CGFloat(1)
                    if $0.offset > 0 && !floor[$0.offset - 1] || $0.offset < cols - 1 && !floor[$0.offset + 1] {
                        name = y == rows - 1 ? "grass-border" : "ground-border"
                        scale = !floor[$0.offset - 1] ? 1 : -1
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
                    origin = CGPoint(x:size.width * CGFloat($0.offset), y:size.height * CGFloat(rows) - 5)
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
    }
    
    private func renderNodes(_ node:SKNode) {
        nodes.enumerated().forEach {
            switch $0.element {
            case .block: node.addChild(renderBlock($0.offset))
            default: break
            }
        }
    }
    
    private func renderBlock(_ index:Int) -> SKNode {
        let node = SKSpriteNode(imageNamed:"grass-block")
        node.size = size
        node.position = CGPoint(x:CGFloat(index) * size.width + (size.width / 2),
                                y:6 * size.height + (size.height / 2))
        return node
    }
}
