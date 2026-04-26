//
//  ContentView.swift
//  todo_list
//
//  Created by MacBook on 22/4/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var showingAddSheet = false
    @State private var selectedTodo: TodoItem?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with stats
                headerView
                
                // Add todo section
                addTodoSection
                
                // Todo list
                todoList
            }
            .navigationTitle("My Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                
                if viewModel.completedTodosCount > 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Clear Completed") {
                            viewModel.deleteCompletedTodos()
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTodoView(viewModel: viewModel)
            }
            .sheet(item: $selectedTodo) { todo in
                EditTodoView(viewModel: viewModel, todo: todo)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("\(viewModel.pendingTodosCount) tasks pending")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                CircularProgressView(progress: viewModel.completionPercentage)
                    .frame(width: 60, height: 60)
            }
            .padding(.horizontal)
            
            // Progress bar
            ProgressView(value: viewModel.completionPercentage)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
    }
    
    private var addTodoSection: some View {
        HStack(spacing: 12) {
            TextField("What needs to be done?", text: $viewModel.newTodoTitle)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .onSubmit {
                    viewModel.addTodo()
                }
            
            Button(action: viewModel.addTodo) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(viewModel.newTodoTitle.isEmpty ? .gray : .blue)
            }
            .disabled(viewModel.newTodoTitle.isEmpty)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    private var todoList: some View {
        List {
            ForEach(viewModel.todos) { todo in
                TodoRowView(todo: todo, viewModel: viewModel)
                    .onTapGesture {
                        selectedTodo = todo
                    }
            }
            .onDelete(perform: deleteTodos)
        }
        .listStyle(PlainListStyle())
    }
    
    private func deleteTodos(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteTodo(viewModel.todos[index])
        }
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    let viewModel: TodoViewModel
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Priority indicator
            Image(systemName: todo.priority.icon)
                .foregroundColor(Color(todo.priority.color))
                .font(.caption)
            
            // Completion checkbox
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.toggleTodoCompletion(todo)
                }
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Todo content
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
                
                HStack {
                    Text(todo.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text(todo.createdAt, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(isPressed ? Color(.systemGray6) : Color.clear)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ContentView()
}
