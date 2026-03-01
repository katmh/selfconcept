import SwiftUI

struct DetailView: View {
    @Environment(AppViewModel.self) var viewModel
    let identity: Identity
    let windowSize: Int

    var completionRate: Double {
        viewModel.getCompletionRate(identityId: identity.id, days: windowSize)
    }

    var body: some View {
        ZStack {
            // Top half: Ideal (saturated green)
            VStack {
                VStack(spacing: 16) {
                    Text("Ideal Self")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(identity.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.0, green: 0.8, blue: 0.2)) // Saturated green

            // Bottom half: Actual (pastel green based on completion rate)
            VStack {
                Spacer()
                VStack(spacing: 16) {
                    Text("Actual Self")
                        .font(.headline)
                        .foregroundColor(.white)
                    HStack(spacing: 8) {
                        Text("\(Int(completionRate * 100))%")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                        Text("of the way there")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(
                    red: 0.5 + (0.3 * completionRate),
                    green: 0.8 + (0.0 * completionRate),
                    blue: 0.4 + (0.0 * completionRate)
                )
            )
            .opacity(0.5)
        }
        .ignoresSafeArea()
        .navigationTitle(identity.action)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DetailView(identity: Identity(name: "I'm fit", action: "gym checkin"), windowSize: 7)
            .environment(AppViewModel())
    }
}
