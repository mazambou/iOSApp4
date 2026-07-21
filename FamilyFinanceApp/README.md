# Family Finance Canada

Family Finance Canada is a SwiftUI prototype for tracking a household monthly budget in Canadian dollars. The app includes income, expenses, transaction management, and spending statistics.

## Original Six SwiftUI Features

1. `ProgressView` on the Home screen to show how much of the monthly budget has been used.
2. `searchable` on the Transactions screen to search by transaction name, category, or type.
3. `swipeActions` on transaction rows for quick edit and delete actions.
4. `contextMenu` on transaction rows for edit, duplicate, and delete actions.
5. `DatePicker` in the Add/Edit Transaction form.
6. `Charts` on the Statistics screen to show spending by category.

## Additional Six SwiftUI Features

1. `Gauge` on the Home screen to show budget health.
2. `DisclosureGroup` on the Home screen to expand or collapse recent transactions.
3. Segmented `Picker` on the Transactions screen to filter All, Income, or Expenses.
4. Toolbar `Menu` on the Transactions screen to sort by date or amount.
5. `confirmationDialog` before deleting a transaction from swipe actions or the context menu.
6. `@AppStorage` on the Settings screen to persist the selected app theme.

## Extra Improvements

- `NavigationLink` opens a transaction detail screen.
- `SettingsView` lets the user choose System, Light, or Dark appearance.
- `Toggle` stores a simple budget-tip preference.
- Shared `FinanceStore` keeps all tabs synchronized.
