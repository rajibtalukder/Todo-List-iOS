//
//  TodoItem.swift
//  todo_list
//
//  Created by MacBook on 22/4/26.
//

import Foundation

struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
