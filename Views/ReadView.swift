import SwiftUI

struct ReadView: View {
    @Environment(AppViewModel.self) var viewModel
    @State private var selectedWindow = 7
    let windowOptions = [7, 14, 30]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Time window picker
                Picker("Time Window", selection: $selectedWindow) {
                    ForEach(windowOptions, id: \.self) { window in
                        Text("\(window) days").tag(window)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if viewModel.appData.identities.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "eye.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("Nothing to see yet")
                            .font(.headline)
                        Text("Go to Setup to add your first identity")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.appData.identities) { identity in
                                IdentitySummaryCard(
                                    identity: identity,
                                    completionRate: viewModel.getCompletionRate(identityId: identity.id, days: selectedWindow),
                                    windowSize: selectedWindow
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Read")
        }
    }
}

struct IdentitySummaryCard: View {
    let identity: Identity
    let completionRate: Double
    let windowSize: Int

    var body: some View {
        NavigationLink(destination: DetailView(identity: identity, windowSize: windowSize)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(identity.name)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(identity.action)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(Int(completionRate * 100))%")
                        .font(.headline)
                        .foregroundColor(.black)
                }

                // Visual representation: two bars
                HStack(spacing: 12) {
                    // Ideal (100% saturated green)
                    VStack(alignment: .leading) {
                        Text("Ideal")
                            .font(.caption)
                            .foregroundColor(.gray)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.0, green: 0.8, blue: 0.2)) // Saturated green
                            .frame(height: 40)
                    }

                    // Actual (pastel green at completion rate saturation)
                    VStack(alignment: .leading) {
                        Text("Actual")
                            .font(.caption)
                            .foregroundColor(.gray)
                        ZStack(alignment: .leading) {
                            // Background (light gray)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray5))

                            // Filled portion (pastel green at completion rate)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(
                                    red: 0.5 + (0.3 * completionRate),
                                    green: 0.8 + (0.0 * completionRate),
                                    blue: 0.4 + (0.0 * completionRate)
                                ))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scaleEffect(x: completionRate, y: 1, anchor: .leading)
                        }
                        .frame(height: 40)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

#Preview {
    ReadView()
        .environment(AppViewModel())
}
