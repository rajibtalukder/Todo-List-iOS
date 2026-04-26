//
//  TodoItem.swift
//  todo_list
//
//  Created by MacBook on 22/4/26.
//

import Foundation

struct TodoItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var priority: Priority
    var category: String
    var createdAt: Date
    var completedAt: Date?
    
    enum Priority: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var color: String {
            switch self {
            case .low: return "green"
            case .medium: return "orange"
            case .high: return "red"
            }
        }
        
        var icon: String {
            switch self {
            case .low: return "arrow.down.circle"
            case .medium: return "minus.circle"
            case .high: return "arrow.up.circle"
            }
        }
    }
    
    init(title: String, isCompleted: Bool = false, priority: Priority = .medium, category: String = "General") {
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.category = category
        self.createdAt = Date()
    }
}
