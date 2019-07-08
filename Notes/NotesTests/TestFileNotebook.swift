//
//  TestFileNotebook.swift
//  NotesTests
//
//  Created by Волнухин Виктор on 06/07/2019.
//  Copyright © 2019 Волнухин Виктор. All rights reserved.
//

import XCTest
@testable import Notes

class TestFileNotebook: XCTestCase {
    
    var note: Note!
    var notebook: FileNotebook!
    var cachesDirectoryPath: URL!
    var filePath: URL!
    

    override func setUp() {
        note = Note(uid: UUID().uuidString, title: "Europe Trip", content: "1. Find friends for trip. 2. Booking hotel. 3. Let's go!", color: .yellow, importance: .usual, selfDestructionDate: Date().addingTimeInterval(50000))
        notebook = FileNotebook()
        cachesDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        filePath = cachesDirectoryPath.appendingPathComponent("Notebook").appendingPathExtension("bin")
    }
    
    override func tearDown() {
        notebook = nil
    }

    
    // Проверка на дубли, при добавлении заметки в коллекцию в файле FileNotebook.
    func testDuplicationWhenAddNewNote() {
        notebook.add(note)
        notebook.add(note)
        let duplicateNotes = notebook.notes.filter { $0.uid == note.uid }
        let hasDuplicatedNotes = duplicateNotes.count < 2
        XCTAssertTrue(hasDuplicatedNotes)
    }
    
    // Проверка на удаление корректной заметки из коллекции в файле FileNotebook.
    func testRemovingCorrectNotesFromCollection() {
        notebook.add(note)
        XCTAssertEqual(notebook.notes.count, 1)
        notebook.remove(with: note.uid)
        XCTAssertEqual(notebook.notes.count, 0)
    }
    
    // Проверка на корректное добавление заметки в коллекцию в файле FileNotebook.
    func testCorrectAddingNoteInCollection() {
        notebook.add(note)
        XCTAssertEqual(notebook.notes.count, 1)
    }
    
    // Проверка создания папки .caches, если она не существует, при сохранении файла.
    func testCreatingCachesWhenSavingFile() {
        notebook.add(note)
        notebook.saveToFile()
        
        var isDirectory: ObjCBool = true
        let isCachesDirectoryCreate = FileManager.default.fileExists(atPath: cachesDirectoryPath.path, isDirectory: &isDirectory)
        XCTAssertTrue(isCachesDirectoryCreate)
    }
    
    // Проверка создания файла с данными, если папка .caches существует и нормально сериализованы данные из json.
    func testCreatingFileWhenSavingFile() {
        notebook.add(note)
        notebook.saveToFile()
        let isFileExist = FileManager.default.fileExists(atPath: filePath.path)
        XCTAssertTrue(isFileExist)
    }
    
    // Проверка на существование файла при его загрузке.
    func testFileExistWhenLoadingFile() {
        notebook.loadFromFile()
        let isFileExist = FileManager.default.fileExists(atPath: filePath.path)
        XCTAssertTrue(isFileExist)
    }
    
    // Проверка на корректное извлечение данных, если файл существует.
    func testCorrectExportDataFromLoadingFile() {
        notebook.loadFromFile()
        XCTAssertTrue(notebook.notes.count > 0)
    }
    
}
