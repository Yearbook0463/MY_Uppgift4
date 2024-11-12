//
//  UpsertTodoView.swift
//  MY_Uppgift4
//
//  Created by elias on 2024-11-12.
//
import SwiftUI
import Foundation

struct UpsertTodoView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var todoId: String
    @Binding var todoTitle: String
    @Binding var todoDesc: String
    @Binding var todoDeadline: Date

    var onSave: (String, String, String, Date) -> Void
    var resetStateCache: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $todoTitle)
                TextField("Description", text: $todoDesc)
                DatePicker("Deadline", selection: $todoDeadline, displayedComponents: [.date, .hourAndMinute])
            }
            .navigationTitle(todoId.isEmpty ? "Add Todo" : "Edit Todo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        resetStateCache()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(todoId, todoTitle, todoDesc, todoDeadline)
                        resetStateCache()
                        dismiss()
                    }
                }
            }
        }
    }
}
