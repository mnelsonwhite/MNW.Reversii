//
//  PositionTests.swift
//  ReversiiTests
//
//  Created by Matthew Nelson-White on 10/10/21.
//

import XCTest
@testable import Reversii

class PositionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWhenCoordPosition_ShouldExpectedOrd() throws {
        // Arrange
        let p = Position(x: 1, y: 1)
        
        // Act
        let actual = p.ordinal
        
        // Assert
        XCTAssertEqual(0, actual)
    }
    
    func testWhenOrdPosition_ShouldExpectedCoord() throws {
        // Arrange
        let p = Position(ordinal: 0)
        
        // Act
        let actualx = p.x
        let actualy = p.y
        
        // Assert
        XCTAssertEqual(actualx, 1)
        XCTAssertEqual(actualy, 1)
    }

}
