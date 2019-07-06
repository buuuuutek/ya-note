//
//  NotesTests.swift
//  NotesTests
//
//  Created by Волнухин Виктор on 05/07/2019.
//  Copyright © 2019 Волнухин Виктор. All rights reserved.
//

import XCTest
@testable import Notes

class NotesTests: XCTestCase {
    
    var standartNote: Note!
    var fullNote: Note!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        standartNote = Note(title: "Today things", content: "Today todo list:", importance: .usual)
        fullNote = Note(uid: UUID().uuidString, title: "My mom dirthday party", content: "1. Invite grand parents;\n2.Cook tasty cookies;\n3.Buy balloons.", color: .purple, importance: .important, selfDestructionDate: Date().addingTimeInterval(1000000))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    /// 1. Проверка всех полей структуры Note на иммутабельность.
    func testNote_mainFieldsNotNil() {
        XCTAssertNotNil(standartNote.uid)
        XCTAssertNotNil(standartNote.title)
        XCTAssertNotNil(standartNote.content)
    }

}
