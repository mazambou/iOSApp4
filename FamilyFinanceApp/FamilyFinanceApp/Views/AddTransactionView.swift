import SwiftUI

struct AddTransactionView: View {
    @Bindable var store: FinanceStore
    @State private var didSave = false

    var body: some View {
        NavigationStack {
            TransactionFormView { transaction in
                store.add(transaction)
                didSave = true
            }
            .navigationTitle("Add")
            .alert("Transaction Added", isPresented: $didSave) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your transaction was saved.")
            }
        }
    }
}

#Preview {
    AddTransactionView(store: FinanceStore())
}
