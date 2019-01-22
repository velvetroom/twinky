import XCTest
import SpriteKit
@testable import Game

class TestArea:XCTestCase {
    private var area:Area!
    
    override func setUp() {
        area = Area()
        area.cols = 1
        area.rows = 1
    }
    
    func testAreaCols() {
        area.cols = 3
        XCTAssertEqual(area.size.width * 3, area.make().calculateAccumulatedFrame().width)
    }
    
    func testAreaRows() {
        area.rows = 3
        XCTAssertLessThanOrEqual(area.size.height * 3, area.make().calculateAccumulatedFrame().height)
    }
    
    func testHasTiles() {
        XCTAssertNotNil((area.make().children.first as? SKSpriteNode)?.texture)
    }
    
    func testZIndex() {
        XCTAssertEqual(-1, area.make().zPosition)
    }
    
    func testMakeMakesPlan() {
        _ = area.make()
        XCTAssertFalse(area.floor.isEmpty)
    }
    
    func testPlanSize() {
        area.cols = 10
        area.build()
        XCTAssertEqual(10, area.floor.count)
    }
    
    func testPlanMaxGap() {
        area.cols = 1000
        area.gap = 2
        area.build()
        XCTAssertGreaterThan(3, area.floor.reduce((0, 0)) {
            !$1 ? ($0.0 + 1, max($0.1, $0.0 + 1)) : (0, $0.1)
        }.1 )
    }
    
    func testPlanMinGap() {
        area.cols = 10000
        area.gap = 4
        area.build()
        var minimum = 4
        var current:Int?
        area.floor.forEach {
            if $0 && current != nil {
                minimum = min(minimum, current!)
                current = nil
            } else if !$0 {
                if current == nil {
                    current = 1
                } else {
                    current = current! + 1
                }
            }
        }
        XCTAssertLessThan(1, minimum)
    }
    
    func testPlanMinFloor() {
        area.cols = 10000
        area.gap = 4
        area.build()
        var minimum = 100
        var current:Int?
        area.floor.forEach {
            if !$0 && current != nil {
                minimum = min(minimum, current!)
                current = nil
            } else if $0 {
                if current == nil {
                    current = 1
                } else {
                    current = current! + 1
                }
            }
        }
        XCTAssertLessThan(1, minimum)
    }
    
    func testFirst20NoGap() {
        area.cols = 1000
        area.build()
        for i in 0 ..< 20 { XCTAssertTrue(area.floor[i]) }
    }
    
    func testLast30NoGap() {
        area.cols = 1000
        area.build()
        for i in 970 ..< 1000 { XCTAssertTrue(area.floor[i]) }
    }
    
    func testNodesAreLessThanPlan() {
        area.build()
        area.cols = 10
        XCTAssertGreaterThan(10, area.nodes.count)
    }
}
