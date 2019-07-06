//
//  TestNote.swift
//  NotesTests
//
//  Created by Волнухин Виктор on 06/07/2019.
//  Copyright © 2019 Волнухин Виктор. All rights reserved.
//

import XCTest
@testable import Notes

class TestNote: XCTestCase {
    
    var minimumNote: Note!
    var notStandartNote: Note!
    
    override func setUp() {
        minimumNote = Note(title: "Today things", content: "Today todo list:", importance: .usual)
        notStandartNote = Note(uid: UUID().uuidString, title: "My mom dirthday party", content: "1. Invite grand parents;\n2.Cook tasty cookies;\n3.Buy balloons.", color: .purple, importance: .important, selfDestructionDate: Date().addingTimeInterval(1000000))
    }
    
    func testDefaultValue() {
        let defaultValue = DefaultValue(of: minimumNote)
        defaultValue.testUid()
        defaultValue.testColor()
        defaultValue.testDestructionDate()
    }
 
    func testNotDefaultValue() {
        let notDefaultValue = NotDefaultValue(of: notStandartNote)
        notDefaultValue.testUid()
        notDefaultValue.testColor()
        notDefaultValue.testImportance()
        notDefaultValue.testDestructionDate()
    }
}

// Проверки записи значений по умолчанию
fileprivate class DefaultValue {
   
    let note: Note
    
    init(of note: Note) {
        self.note = note
    }
    
    func testUid() {
        XCTAssertFalse(note.uid.isEmpty)
    }
    
    func testColor() {
        XCTAssertTrue(note.color == .white)
    }
    
    func testDestructionDate() {
        XCTAssertNil(note.selfDestructionDate)
    }
    
}

// Проверки записи значений отличных от значений по умолчанию
fileprivate class NotDefaultValue {
    
    let note: Note
    
    init(of note: Note) {
        self.note = note
    }
    
    func testUid() {
        XCTAssertFalse(note.uid.isEmpty)
    }
    
    func testColor() {
        XCTAssertNotEqual(note.color, UIColor.white)
    }
    
    func testImportance() {
        XCTAssertNotEqual(note.importance, Importance.usual)
    }
    
    func testDestructionDate() {
        XCTAssertNotNil(note.selfDestructionDate)
    }
}
