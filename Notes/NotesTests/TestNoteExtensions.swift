//
//  TestNoteExtensions.swift
//  NotesTests
//
//  Created by Волнухин Виктор on 06/07/2019.
//  Copyright © 2019 Волнухин Виктор. All rights reserved.
//

import XCTest
@testable import Notes

class TestNoteExtensions: XCTestCase {
    
    var minNote: Note!
    var minNoteJson: [String: Any]!
    
    var standartNote: Note!
    var standartNoteJson: [String: Any]!

    override func setUp() {
        // Создание заявки с минимальным набором данных
        minNote = Note(title: "Tomorrow things", content: "Tomorrow I must do...", importance: .usual)
        minNoteJson = minNote.json
        
        // Создание заявки со всеми заполненными полями
        standartNote = Note(uid: UUID().uuidString, title: "My mom birthday party", content: "1. Invite grand parents. 2. Invite her friends. 3. Cook some cookies. 4. Buy a lot of balloons", color: .purple, importance: .important, selfDestructionDate: Date().addingTimeInterval(1000000))
        standartNoteJson = standartNote.json
    }

    
    // Проверка поля json в расширении NoteExtensions на содержание всех необходимых полей.
    func testNeededFieldsInJson() {
        XCTAssertNotNil(minNoteJson["uid"])
        XCTAssertNotNil(minNoteJson["title"])
        XCTAssertNotNil(minNoteJson["content"])
    }

    // Проверка функции parse(json:) на возвращение nil, если поля uid, title и content содержат nil.
    func testNullableParsingWhenNeededFieldsIsNil() {
        let emptyJson = [String: Any]()
        XCTAssertNil(Note.parse(json: emptyJson))
    }
    
    // Проверка функции parse(json:) на возвращение корректного экземпляра Note, в случае корректного json.
    func testParsingWithCorrectJson() {
        XCTAssertNotNil(Note.parse(json: minNoteJson))
    }
    
    // Проверка на НЕсохранение параметра color в json, если он равен .white.
    func testNotSavingColorIfChosenDefaultValue() {
        XCTAssertNil(minNoteJson["color"])
    }
    
    // Проверка на НЕсохранение параметра importance в json, если он равен .usual.
    func testNotSavingImportanceIfChosenDefaultValue() {
        XCTAssertNil(minNoteJson["importance"])
    }
    
    // Проверка на НЕсохранение параметра selfDestructionDate, если он равен nil.
    func testNotSavingDestructionDateIfValueIsNil() {
        XCTAssertNil(minNoteJson["selfDestructionDate"])
    }
    
    // Проверка сохранения selfDestructionDate в json в виде timeInterval1970.
    func testSavingDestructionDateInTimeIntervalType() {
        let destructionDate = standartNoteJson["selfDestructionDate"]
        XCTAssertTrue(destructionDate is TimeInterval)
    }
    
    // Проверка сохранения параметра color в виде словаря компонентов.
    func testSavingColorInDictionaryOfComponents() {
        let color = standartNoteJson["color"]
        XCTAssertTrue(color is [String: Double])
    }
    
    // Проверка сохранения параметра importance в виде rawValue.
    func testSavingImportanceInRawValue() {
        let importance = standartNoteJson["importance"]
        XCTAssertTrue(importance is Int)
    }
    
}
