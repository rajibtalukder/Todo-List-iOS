//
//  AddTodoView.swift
//  todo_list
//
//  Created by MacBook on 22/4/26.
//

import SwiftUI

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var selectedPriority: TodoItem.Priority = .medium
    @State private var category: String = "General"
    
    private let categories = ["General", "Work", "Personal", "Shopping", "Health", "Study"]
    
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
                
                Spacer()
                
                // Add button
                Button(action: addTodo) {
                    Text("Add Task")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(title.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(12)
                }
                .disabled(title.isEmpty)
            }
            .padding()
            .navigationTitle("New Task")
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
    
    private func addTodo() {
        let todo = TodoItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            priority: selectedPriority,
            category: category
        )
        viewModel.todos.append(todo)
        viewModel.saveTodos()
        dismiss()
    }
}
