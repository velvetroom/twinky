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
        XCTAssertFalse(area.plan.isEmpty)
    }
    
    func testPlanSize() {
        area.cols = 10
        area.makePlan()
        XCTAssertEqual(10, area.plan.count)
    }
    
    func testPlanMaxGap() {
        area.cols = 1000
        area.gap = 2
        area.makePlan()
        XCTAssertGreaterThan(3, area.plan.reduce((0, 0)) {
            $1 == 0 ? ($0.0 + 1, max($0.1, $0.0 + 1)) : (0, $0.1)
        }.1 )
    }
    
    func testFirst20NoGap() {
        area.cols = 1000
        area.makePlan()
        for i in 0 ..< 20 { XCTAssertEqual(1, area.plan[i]) }
    }
    
    func testLast30NoGap() {
        area.cols = 1000
        area.makePlan()
        for i in 970 ..< 1000 { XCTAssertEqual(1, area.plan[i]) }
    }
}
