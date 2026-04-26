//
//  EditTodoView.swift
//  todo_list
//
//  Created by MacBook on 22/4/26.
//

import SwiftUI

struct EditTodoView: View {
    @ObservedObject var viewModel: TodoViewModel
    let todo: TodoItem
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var selectedPriority: TodoItem.Priority
    @State private var category: String
    @State private var isCompleted: Bool
    
    private let categories = ["General", "Work", "Personal", "Shopping", "Health", "Study"]
    
    init(viewModel: TodoViewModel, todo: TodoItem) {
        self.viewModel = viewModel
        self.todo = todo
        self._title = State(initialValue: todo.title)
        self._selectedPriority = State(initialValue: todo.priority)
        self._category = State(initialValue: todo.category)
        self._isCompleted = State(initialValue: todo.isCompleted)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Title")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter task title...", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                }
                
                // Priority section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Priority")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                        ForEach(TodoItem.Priority.allCases, id: \.self) { priority in
                            Button(action: {
                                selectedPriority = priority
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: priority.icon)
                                        .font(.title2)
                                        .foregroundColor(selectedPriority == priority ? Color(priority.color) : .gray)
                                    
                                    Text(priority.rawValue)
                                        .font(.caption)
                                        .foregroundColor(selectedPriority == priority ? Color(priority.color) : .gray)
                                }
                                .padding(8)
                                .background(selectedPriority == priority ? Color(priority.color).opacity(0.1) : Color.clear)
                                .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // Category section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(categories, id: \.self) { categoryOption in
                            Button(action: {
                                category = categoryOption
                            }) {
                                Text(categoryOption)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(category == categoryOption ? Color.blue : Color(.systemGray5))
                                    .foregroundColor(category == categoryOption ? .white : .primary)
                                    .cornerRadius(16)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // Completion status
                VStack(alignment: .leading, spacing: 8) {
                    Text("Status")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        isCompleted.toggle()
                    }) {
                        HStack {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundColor(isCompleted ? .green : .gray)
                            
                            Text(isCompleted ? "Completed" : "Pending")
                                .font(.body)
                                .foregroundColor(isCompleted ? .green : .primary)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(12)
                    }
                    .disabled(title.isEmpty)
                    
                    Button(action: deleteTodo) {
                        Text("Delete Task")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private func saveChanges() {
        if let index = viewModel.todos.firstIndex(where: { $0.id == todo.id }) {
            viewModel.todos[index].title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.todos[index].priority = selectedPriority
            viewModel.todos[index].category = category
            viewModel.todos[index].isCompleted = isCompleted
            
            if isCompleted && todo.completedAt == nil {
                viewModel.todos[index].completedAt = Date()
            } else if !isCompleted {
                viewModel.todos[index].completedAt = nil
            }
            
            viewModel.saveTodos()
        }
        dismiss()
    }
    
    private func deleteTodo() {
        viewModel.deleteTodo(todo)
        dismiss()
    }
}
