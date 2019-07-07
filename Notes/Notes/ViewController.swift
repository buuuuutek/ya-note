//
//  ViewController.swift
//  Notes
//
//  Created by Волнухин Виктор on 01/07/2019.
//  Copyright © 2019 Волнухин Виктор. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //
        // TODO: repair save and load from/to file
        //
        
        // Создаём заметку
        let note = Note(title: "Hello world", content: "It's first note of this application", color: .red, importance: .important, selfDestructionDate: Date())
        
        // Создаём записную книжку
        let notebook = FileNotebook()
        
        // Добавляем ранее созданную заметку
        notebook.add(note)
        // Проверяем добавление
        print(notebook.notes)
        
        // Сохраняем в файл
        notebook.saveToFile()
        
        // Удаляем из локальной записной книжки ранее созданную заметку
        notebook.remove(with: note.uid)
        // Проверяем удаление
        print(notebook.notes)
        
        // Загружаем заметку из файла
        notebook.loadFromFile()
        // Проверяем загруженную из файла заметку
        print(notebook.notes)
        
    }


}

