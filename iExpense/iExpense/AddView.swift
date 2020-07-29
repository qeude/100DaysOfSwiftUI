//
//  AddView.swift
//  iExpense
//
//  Created by Quentin Eude on 29/07/2020.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses

    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showingAlert = false

    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.showingAlert = true
                }
            })
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Incorrect amount"),
                  message: Text("Amount must be an integer"),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
