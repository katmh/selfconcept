import SwiftUI

struct WriteView: View {
    @Environment(AppViewModel.self) var viewModel

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.appData.identities.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No identities yet")
                            .font(.headline)
                        Text("Go to Setup to add your first identity")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    List {
                        ForEach(viewModel.getLogsForPastDays(14), id: \.date) { log in
                            DayLogSection(date: log.date, log: log)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Write")
        }
    }
}

struct DayLogSection: View {
    @Environment(AppViewModel.self) var viewModel
    let date: Date
    var log: DailyLog

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dateFormatter.string(from: date))
                .font(.headline)
                .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.appData.identities) { identity in
                    let actionLog = log.actions.first { $0.identityId == identity.id }
                    let isCompleted = actionLog?.completed ?? false

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isCompleted ? .green : .gray)
                            Text(identity.action)
                                .font(.body)
                            Spacer()
                        }
                        .onTapGesture {
                            viewModel.updateCompletion(
                                identityId: identity.id,
                                date: date,
                                completed: !isCompleted,
                                note: actionLog?.note
                            )
                        }

                        if let note = actionLog?.note, !note.isEmpty {
                            Text(note)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d"
    return formatter
}()

#Preview {
    WriteView()
        .environment(AppViewModel())
}
