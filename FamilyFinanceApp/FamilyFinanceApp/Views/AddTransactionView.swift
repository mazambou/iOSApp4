import SwiftUI

struct AddTransactionView: View {
    @Bindable var store: FinanceStore
    @State private var didSave = false

    var body: some View {
        NavigationStack {
            // The form returns a completed FinanceTransaction through the onSave closure.
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
