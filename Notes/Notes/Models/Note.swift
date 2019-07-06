//
//  Note.swift
//  Notes
//
//  Created by Волнухин Виктор on 20/06/2019.
//  Copyright © 2019 Волнухин Виктор. All rights reserved.
//

import UIKit

struct Note {
 
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    
    init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor = .white, importance: Importance, selfDestructionDate: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
}

