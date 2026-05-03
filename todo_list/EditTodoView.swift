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
    @State private var animateBackground = false
    
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
            ZStack {
                // Animated gradient background
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                    startPoint: animateBackground ? .topLeading : .bottomTrailing,
                    endPoint: animateBackground ? .bottomTrailing : .topLeading
                )
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                        animateBackground = true
                    }
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Title section with glassmorphism
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Task Title")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            TextField("Enter task title...", text: $title)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.ultraThinMaterial)
                                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                )
                        }
                        
                        // Priority section with enhanced design
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Priority")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 16) {
                                ForEach(TodoItem.Priority.allCases, id: \.self) { priority in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedPriority = priority
                                        }
                                    }) {
                                        VStack(spacing: 8) {
                                            ZStack {
                                                Circle()
                                                    .fill(
                                                        LinearGradient(
                                                            colors: priorityGradientColors(for: priority),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .frame(width: 44, height: 44)
                                                    .shadow(color: priorityColor(for: priority).opacity(0.3), radius: 8, x: 0, y: 4)
                                            }
                                            .scaleEffect(selectedPriority == priority ? 1.1 : 1.0)
                                            
                                            Text(priority.rawValue)
                                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                                .foregroundColor(selectedPriority == priority ? priorityColor(for: priority) : .secondary)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        // Category section with modern pills
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(categories, id: \.self) { categoryOption in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            category = categoryOption
                                        }
                                    }) {
                                        Text(categoryOption)
                                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                category == categoryOption ?
                                                LinearGradient(
                                                    colors: categoryGradientColors(for: categoryOption),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ) :
                                                LinearGradient(
                                                    colors: [Color(.systemGray6)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .foregroundColor(category == categoryOption ? .white : .primary)
                                            .cornerRadius(20)
                                            .shadow(color: category == categoryOption ? categoryColor(for: categoryOption).opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .scaleEffect(category == categoryOption ? 1.05 : 1.0)
                                }
                            }
                        }
                        
                        // Completion status with modern toggle
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Status")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    isCompleted.toggle()
                                }
                            }) {
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(isCompleted ? LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Color(.systemGray6)], startPoint: .leading, endPoint: .trailing))
                                            .frame(width: 60, height: 32)
                                            .shadow(color: isCompleted ? Color.green.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
                                        
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 26, height: 26)
                                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                            .offset(x: isCompleted ? 14 : -14)
                                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCompleted)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(isCompleted ? "Completed" : "Pending")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .foregroundColor(isCompleted ? .green : .primary)
                                        
                                        Text(isCompleted ? "Task is done" : "Task in progress")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.ultraThinMaterial)
                                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Spacer()
                        
                        // Action buttons with modern design
                        VStack(spacing: 16) {
                            Button(action: saveChanges) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                    
                                    Text("Save Changes")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    LinearGradient(
                                        colors: title.isEmpty ? [.gray] : [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: title.isEmpty ? Color.clear : Color.blue.opacity(0.3), radius: 12, x: 0, y: 6)
                            }
                            .disabled(title.isEmpty)
                            .scaleEffect(title.isEmpty ? 0.95 : 1.0)
                            .opacity(title.isEmpty ? 0.6 : 1.0)
                            
                            Button(action: deleteTodo) {
                                HStack {
                                    Image(systemName: "trash.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                    
                                    Text("Delete Task")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    LinearGradient(
                                        colors: [.red, .pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.red.opacity(0.3), radius: 12, x: 0, y: 6)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private func saveChanges() {
        if let index = viewModel.todos.firstIndex(where: { $0.id == todo.id }) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
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
        }
        dismiss()
    }
    
    private func deleteTodo() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            viewModel.deleteTodo(todo)
        }
        dismiss()
    }
    
    private func priorityColor(for priority: TodoItem.Priority) -> Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    private func priorityGradientColors(for priority: TodoItem.Priority) -> [Color] {
        switch priority {
        case .high: return [.red, .pink]
        case .medium: return [.orange, .yellow]
        case .low: return [.green, .mint]
        }
    }
    
    private func categoryColor(for category: String) -> Color {
        switch category {
        case "Work": return .blue
        case "Personal": return .pink
        case "Shopping": return .orange
        case "Health": return .green
        case "Study": return .indigo
        default: return .gray
        }
    }
    
    private func categoryGradientColors(for category: String) -> [Color] {
        switch category {
        case "Work": return [.blue, .purple]
        case "Personal": return [.pink, .purple]
        case "Shopping": return [.orange, .red]
        case "Health": return [.green, .mint]
        case "Study": return [.indigo, .blue]
        default: return [.gray, .secondary]
        }
    }
}
