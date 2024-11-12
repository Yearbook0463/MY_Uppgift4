//
//  TodoListSection.swift
//  MY_Uppgift4
//
//  Created by elias on 2024-11-12.
//
import Foundation
import SwiftUI

struct TodoListSection: View {
    var items: [TodoItem]
    let toggleCompleted: (TodoItem) -> Void
    let onItemTap: (TodoItem) -> Void
    let deleteItem: (TodoItem) -> Void
    
    var body: some View {
        List {
            ForEach(items) { item in
                HStack {
                    Text(item.todoName)
                        .onTapGesture {
                            onItemTap(item)
                        }
                    
                    Spacer()
                    
                    // Right-aligned status label
                    Text(item.completed == nil
                                    ? "Incomplete\nDeadline: \(item.todoDeadline.formatted())"
                                    : "Completed on\n\(item.completed!.formatted())")
                                    .foregroundColor(item.completed == nil ? .red : .green)
                                    .font(.caption)
                                    .multilineTextAlignment(.trailing)
                }
                .padding()
                .cornerRadius(8)
                .swipeActions {
                    Button(item.completed == nil ? "Complete" : "Undo") {
                        toggleCompleted(item)
                    }
                    .tint(item.completed == nil ? .green : .orange)
                    Button("Delete") {
                        deleteItem(item)
                    }
                    .tint(.red)
                }
            }
        }
    }
}
