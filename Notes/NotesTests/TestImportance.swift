//
//  TestImportance.swift
//  NotesTests
//
//  Created by Волнухин Виктор on 06/07/2019.
//  Copyright © 2019 Волнухин Виктор. All rights reserved.
//

import XCTest
@testable import Notes

class TestImportance: XCTestCase {

    func testImportanceEnumeration() {
        XCTAssertEqual(Importance.unimportant.rawValue, 0)
        XCTAssertEqual(Importance.usual.rawValue, 1)
        XCTAssertEqual(Importance.important.rawValue, 2)
    }

    func testNonexistentRawValue() {
        XCTAssertNil(Importance(rawValue: 4))
    }
}
