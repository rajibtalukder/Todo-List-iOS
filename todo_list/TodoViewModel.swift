//
//  TodoViewModel.swift
//  todo_list
//
//  Created by MacBook on 22/4/26.
//

import Foundation
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var newTodoTitle: String = ""
    
    init() {
        loadTodos()
    }
    
    func addTodo() {
        guard !newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let todo = TodoItem(title: newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines))
        todos.append(todo)
        newTodoTitle = ""
        saveTodos()
    }
    
    func toggleTodoCompletion(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        todos.removeAll { $0.id == todo.id }
        saveTodos()
    }
    
    func deleteCompletedTodos() {
        todos.removeAll { $0.isCompleted }
        saveTodos()
    }
    
    var completedTodosCount: Int {
        todos.filter { $0.isCompleted }.count
    }
    
    var pendingTodosCount: Int {
        todos.filter { !$0.isCompleted }.count
    }
    
    var completionPercentage: Double {
        guard todos.count > 0 else { return 0 }
        return Double(completedTodosCount) / Double(todos.count)
    }
    
    func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: "todos")
        }
    }
    
    private func loadTodos() {
        if let data = UserDefaults.standard.data(forKey: "todos"),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos = decoded
        }
    }
}
