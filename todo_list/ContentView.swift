//
//  ContentView.swift
//  todo_list
//
//  Created by MacBook on 22/4/26.
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [TodoItem] = []
    @State private var newTodoTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("New todo...", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Add") {
                        if !newTodoTitle.isEmpty {
                            todos.append(TodoItem(title: newTodoTitle))
                            newTodoTitle = ""
                        }
                    }
                    .padding(.leading, 8)
                }
                .padding()
                
                List {
                    ForEach(todos) { todo in
                        HStack {
                            Button(action: {
                                if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                                    todos[index].isCompleted.toggle()
                                }
                            }) {
                                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(todo.isCompleted ? .green : .gray)
                            }
                            
                            Text(todo.title)
                                .strikethrough(todo.isCompleted)
                                .foregroundColor(todo.isCompleted ? .gray : .primary)
                            
                            Spacer()
                            
                            Button(action: {
                                todos.removeAll { $0.id == todo.id }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Todo List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
