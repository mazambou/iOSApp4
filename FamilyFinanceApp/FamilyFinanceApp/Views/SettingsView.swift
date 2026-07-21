import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

struct SettingsView: View {
    @AppStorage("appTheme") private var selectedTheme = AppTheme.system.rawValue
    @AppStorage("showBudgetTips") private var showBudgetTips = true
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    private var theme: AppTheme {
        AppTheme(rawValue: selectedTheme) ?? .system
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.rawValue).tag(theme.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Preferences") {
                    Toggle("Show Budget Tips", isOn: $showBudgetTips)

                    if showBudgetTips {
                        Text("Keep housing, groceries, and transportation visible to catch overspending early.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Current Selection") {
                    LabeledContent("Theme", value: theme.rawValue)
                    LabeledContent("Currency", value: "CAD")
                }

                Section("Account") {
                    Button(role: .destructive) {
                        isLoggedIn = false
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
