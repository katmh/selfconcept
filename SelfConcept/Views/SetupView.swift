import SwiftUI

struct SetupView: View {
    @Environment(AppViewModel.self) var viewModel
    @State private var identityName = ""
    @State private var actionName = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Form {
                    Section("New Identity") {
                        TextField("Identity (e.g., \"I'm fit\")", text: $identityName)
                        TextField("Action (e.g., \"gym checkin\")", text: $actionName)
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

        viewModel.addIdentity(name: name, action: action)
        identityName = ""
        actionName = ""
    }
}

#Preview {
    SetupView()
        .environment(AppViewModel())
}
