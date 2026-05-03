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
    @State private var animateBackground = false
    
    @State private var title: String = ""
    @State private var selectedPriority: TodoItem.Priority = .medium
    @State private var category: String = "General"
    @State private var isPressed = false
    
    private let categories = ["General", "Work", "Personal", "Shopping", "Health", "Study"]
    
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
                        
                        Spacer()
                        
                        // Add button with modern design
                        Button(action: addTodo) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("Add Task")
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
                        .padding(.bottom, 20)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Task")
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
    
    private func addTodo() {
        let todo = TodoItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            priority: selectedPriority,
            category: category
        )
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            viewModel.todos.append(todo)
            viewModel.saveTodos()
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
