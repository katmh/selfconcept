import SwiftUI

struct SetupView: View {
    @Environment(AppViewModel.self) var viewModel
    @State private var identityName = ""
    @State private var actionName = ""
    @State private var frequencyType = "week"
    @State private var frequencyCount = 3

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Form {
                    Section("New Identity") {
                        TextField("Identity (e.g., \"I'm fit\")", text: $identityName)
                        TextField("Action (e.g., \"gym checkin\")", text: $actionName)

                        Picker("Frequency", selection: $frequencyType) {
                            Text("Times per week").tag("week")
                            Text("Times per month").tag("month")
                        }

                        Stepper("Count: \(frequencyCount)", value: $frequencyCount, in: 1...30)
                    }

                    Button(action: addIdentity) {
                        Text("Add Identity")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(identityName.trimmingCharacters(in: .whitespaces).isEmpty || actionName.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                Section("Your Identities") {
                    if viewModel.appData.identities.isEmpty {
                        Text("No identities yet. Add one above!")
                            .foregroundColor(.gray)
                    } else {
                        List {
                            ForEach(viewModel.appData.identities) { identity in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(identity.name)
                                        .font(.headline)
                                    Text(identity.action)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(identity.frequency.displayString)
                                        .font(.caption2)
                                        .foregroundColor(.blue)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteIdentity(identity.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("Setup")
        }
    }

    private func addIdentity() {
        let name = identityName.trimmingCharacters(in: .whitespaces)
        let action = actionName.trimmingCharacters(in: .whitespaces)

        guard !name.isEmpty && !action.isEmpty else { return }

        let frequency: FrequencyType = frequencyType == "week"
            ? .perWeek(frequencyCount)
            : .perMonth(frequencyCount)

        viewModel.addIdentity(name: name, action: action, frequency: frequency)
        identityName = ""
        actionName = ""
        frequencyType = "week"
        frequencyCount = 3
    }
}

#Preview {
    SetupView()
        .environment(AppViewModel())
}
