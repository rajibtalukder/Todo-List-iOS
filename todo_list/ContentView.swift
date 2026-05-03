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
    @State private var animateGradient = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    // Background gradient
                    LinearGradient(
                        colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                        startPoint: animateGradient ? .topLeading : .bottomTrailing,
                        endPoint: animateGradient ? .bottomTrailing : .topLeading
                    )
                    .ignoresSafeArea()
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                            animateGradient = true
                        }
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            // Header with stats
                            headerView
                                .padding(.top, 20)
                            
                            // Add todo section
                            addTodoSection
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                            
                            // Todo list
                            todoList
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                        }
                    }
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
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("\(viewModel.pendingTodosCount) tasks pending")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5).opacity(0.3), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.completionPercentage)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1), value: viewModel.completionPercentage)
                    
                    VStack {
                        Text("\(Int(viewModel.completionPercentage * 100))%")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        Text("Done")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Progress bar with gradient
            VStack(spacing: 8) {
                ProgressView(value: viewModel.completionPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: .clear))
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .scaleEffect(x: viewModel.completionPercentage, y: 1, anchor: .leading)
                            .animation(.easeInOut(duration: 1), value: viewModel.completionPercentage)
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.black)
                    )
                
                HStack {
                    Text("\(viewModel.completedTodosCount) completed")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(viewModel.todos.count) total")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
    }
    
    private var addTodoSection: some View {
        HStack(spacing: 16) {
            TextField("What needs to be done?", text: $viewModel.newTodoTitle)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .onSubmit {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.addTodo()
                    }
                }
            
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    viewModel.addTodo()
                }
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: viewModel.newTodoTitle.isEmpty ? [.gray] : [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .disabled(viewModel.newTodoTitle.isEmpty)
            .scaleEffect(viewModel.newTodoTitle.isEmpty ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.newTodoTitle.isEmpty)
        }
    }
    
    private var todoList: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.todos) { todo in
                TodoRowView(todo: todo, viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 0.8).combined(with: .opacity)
                    ))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTodo = todo
                        }
                    }
            }
            .onDelete(perform: deleteTodos)
        }
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
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Priority indicator with gradient
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: priorityColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                
                Image(systemName: todo.priority.icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            
            // Completion checkbox with animation
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    viewModel.toggleTodoCompletion(todo)
                }
            }) {
                ZStack {
                    Circle()
                        .stroke(todo.isCompleted ? Color.green.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if todo.isCompleted {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.green, .mint],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .scaleEffect(todo.isCompleted ? 1.0 : 0.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: todo.isCompleted)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Todo content with enhanced typography
            VStack(alignment: .leading, spacing: 6) {
                Text(todo.title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 8) {
                    // Category badge with gradient
                    Text(todo.category)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            LinearGradient(
                                colors: categoryColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    // Time indicator
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(todo.createdAt, style: .time)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(isPressed ? 0.15 : 0.08), radius: isPressed ? 8 : 4, x: 0, y: isPressed ? 4 : 2)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .rotation3DEffect(
            .degrees(isPressed ? 2 : 0),
            axis: (x: 1, y: 0, z: 0)
        )
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var priorityColors: [Color] {
        switch todo.priority {
        case .high: return [.red, .pink]
        case .medium: return [.orange, .yellow]
        case .low: return [.green, .mint]
        }
    }
    
    private var categoryColors: [Color] {
        switch todo.category {
        case "Work": return [.blue, .purple]
        case "Personal": return [.pink, .purple]
        case "Shopping": return [.orange, .red]
        case "Health": return [.green, .mint]
        case "Study": return [.indigo, .blue]
        default: return [.gray, .secondary]
        }
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
