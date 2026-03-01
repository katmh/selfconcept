import Foundation
import Observation

@Observable
class AppViewModel {
    var appData: AppData = AppData()

    init() {
        loadData()
    }

    // MARK: - Data Persistence

    private func loadData() {
        appData = PersistenceManager.shared.load()
    }

    private func saveData() {
        try? PersistenceManager.shared.save(appData)
    }

    // MARK: - Identity Management

    func addIdentity(name: String, action: String) {
        let identity = Identity(name: name, action: action)
        appData.identities.append(identity)
        saveData()
    }

    func deleteIdentity(_ id: UUID) {
        appData.identities.removeAll { $0.id == id }
        // Also remove all logs for this identity
        appData.dailyLogs = appData.dailyLogs.map { log in
            var updatedLog = log
            updatedLog.actions.removeAll { $0.identityId == id }
            return updatedLog
        }
        saveData()
    }

    // MARK: - Daily Logging

    func getOrCreateLog(for date: Date) -> DailyLog {
        let normalizedDate = Calendar.current.startOfDay(for: date)

        if let existingLog = appData.dailyLogs.first(where: { log in
            Calendar.current.isDate(log.date, inSameDayAs: normalizedDate)
        }) {
            return existingLog
        }

        // Create a new log with empty actions for all identities
        let newLog = DailyLog(
            date: normalizedDate,
            actions: appData.identities.map { ActionLog(identityId: $0.id, completed: false, note: nil) }
        )
        appData.dailyLogs.append(newLog)
        saveData()
        return newLog
    }

    func updateCompletion(identityId: UUID, date: Date, completed: Bool, note: String?) {
        let normalizedDate = Calendar.current.startOfDay(for: date)

        var log = getOrCreateLog(for: normalizedDate)

        if let index = log.actions.firstIndex(where: { $0.identityId == identityId }) {
            log.actions[index].completed = completed
            log.actions[index].note = note
        }

        // Update in appData
        if let logIndex = appData.dailyLogs.firstIndex(where: { l in
            Calendar.current.isDate(l.date, inSameDayAs: normalizedDate)
        }) {
            appData.dailyLogs[logIndex] = log
        }

        saveData()
    }

    // MARK: - Querying

    func getLogsForPastDays(_ count: Int) -> [DailyLog] {
        let today = Calendar.current.startOfDay(for: Date())
        var logsDict: [Date: DailyLog] = [:]

        // First, populate all days in the range (even if no log exists)
        for dayOffset in 0..<count {
            if let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: today) {
                if logsDict[date] == nil {
                    logsDict[date] = DailyLog(date: date, actions: [])
                }
            }
        }

        // Then, fill in actual logs
        for log in appData.dailyLogs {
            let normalizedDate = Calendar.current.startOfDay(for: log.date)
            if logsDict[normalizedDate] != nil {
                logsDict[normalizedDate] = log
            }
        }

        // Return sorted by date (most recent first)
        return logsDict.values.sorted { $0.date > $1.date }
    }

    func getCompletionRate(identityId: UUID, days: Int) -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        var completedDays = 0
        var totalDays = 0

        for dayOffset in 0..<days {
            if let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: today) {
                totalDays += 1

                if let log = appData.dailyLogs.first(where: { l in
                    Calendar.current.isDate(l.date, inSameDayAs: date)
                }) {
                    if let action = log.actions.first(where: { $0.identityId == identityId }),
                       action.completed {
                        completedDays += 1
                    }
                }
            }
        }

        return totalDays > 0 ? Double(completedDays) / Double(totalDays) : 0.0
    }

    func getActionLog(for identity: Identity, date: Date) -> ActionLog? {
        let normalizedDate = Calendar.current.startOfDay(for: date)

        guard let log = appData.dailyLogs.first(where: { l in
            Calendar.current.isDate(l.date, inSameDayAs: normalizedDate)
        }) else {
            return nil
        }

        return log.actions.first { $0.identityId == identity.id }
    }
}
