import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TodoItem]
    @State private var isShowingAddTodo = false
    @State private var selectedItem: TodoItem?
    
    @State private var todoId = ""
    @State private var todoTitle = ""
    @State private var todoDesc = ""
    @State private var todoDeadline = Date()

    private var incompleteItems: [TodoItem] {
        items.filter { $0.completed == nil }
            .sorted { $0.todoDeadline < $1.todoDeadline }
    }
    
    private var completedItems: [TodoItem] {
        items.filter { $0.completed != nil }
    }
    
    private var sortedItems: [TodoItem] {
        var itemList = incompleteItems
        itemList.append(contentsOf: completedItems)
        return itemList
    }

    var body: some View {
        NavigationView {
            VStack {
                TodoListSection(
                    items: sortedItems,
                    toggleCompleted: toggleCompleted,
                    onItemTap: selectItemForEditing,
                    deleteItem: deleteItem
                )
            }
            .toolbar {
            
                ToolbarItem {
                    Button(action: { isShowingAddTodo = true }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddTodo) {
                UpsertTodoView(
                    todoId: $todoId,
                    todoTitle: $todoTitle,
                    todoDesc: $todoDesc,
                    todoDeadline: $todoDeadline,
                    onSave: upsertItem,
                    resetStateCache: resetStateCache
                )
            }
            .sheet(item: $selectedItem) { _ in
                UpsertTodoView(
                    todoId: $todoId,
                    todoTitle: $todoTitle,
                    todoDesc: $todoDesc,
                    todoDeadline: $todoDeadline,
                    onSave: upsertItem,
                    resetStateCache: resetStateCache
                )
            }
        }
    }

    private func selectItemForEditing(_ item: TodoItem) {
        todoId = item.id
        todoTitle = item.todoName
        todoDesc = item.todoDescription
        todoDeadline = item.todoDeadline
        selectedItem = item
    }

    private func deleteItem(_ item: TodoItem) {
        modelContext.delete(item)
    }
    
    private func upsertItem(id: String, title: String, description: String, deadline: Date) {
        let newId = id.isEmpty ? UUID().uuidString : id
        if let existingItem = items.first(where: { $0.id == newId }) {
            existingItem.todoName = title
            existingItem.todoDescription = description
            existingItem.todoDeadline = deadline
        } else {
            let newItem = TodoItem(id: newId, todoName: title, todoDescription: description, todoDeadline: deadline, timestamp: Date(), completed: nil)
            modelContext.insert(newItem)
        }
        resetStateCache()
    }
    private func resetStateCache() {
        todoId = ""
        todoTitle = ""
        todoDesc = ""
        todoDeadline = Date()
        selectedItem = nil
    }

    private func toggleCompleted(_ item: TodoItem) {
        item.completed = item.completed == nil ? Date() : nil
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
