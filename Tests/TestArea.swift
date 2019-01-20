import XCTest
import SpriteKit
@testable import Game

class TestArea:XCTestCase {
    private var area:Area!
    
    override func setUp() {
        area = Area()
        area.cols = 1
    }
    
    func testAreaCols() {
        area.cols = 3
        XCTAssertEqual(area.tileSize.width * 3, area.make().calculateAccumulatedFrame().width)
    }
    
    func testAreaRows() {
        XCTAssertLessThanOrEqual(area.tileSize.height * 6, area.make().calculateAccumulatedFrame().height)
    }
    
    func testHasTiles() {
        XCTAssertNotNil((area.make().children.first?.children.first as? SKSpriteNode)?.texture)
    }
    
    func testHasColor() {
        area.tint = .red
        guard let tile = (area.make().children.first?.children.first as? SKSpriteNode) else { return }
        XCTAssertEqual(1, tile.color.redComponent)
        XCTAssertEqual(0, tile.color.blueComponent)
        XCTAssertEqual(0, tile.color.greenComponent)
        XCTAssertEqual(1, tile.color.alphaComponent)
        XCTAssertEqual(.alpha, tile.blendMode)
        XCTAssertEqual(1, tile.colorBlendFactor)
    }
    
    func testHasBody() {
        XCTAssertNotNil(area.make().children.first?.physicsBody)
    }
    
    func testBodyProperties() {
        guard let body = area.make().children.first?.physicsBody else { return }
        XCTAssertEqual(.floor, body.categoryBitMask)
    }
    
    func testAtLeastOneBlankSpace() {
        area.cols = 3
        XCTAssertGreaterThan(0, area.make().children.reduce(into:(Int(), CGFloat())) {
            if $1.frame.minX >= $0.1 + 32 {
                $0.0 += 1
            }
            $0.1 = $1.frame.maxX
        }.0)
    }
}
