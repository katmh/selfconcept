import Foundation

struct Identity: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String           // "I'm fit"
    var action: String         // "gym checkin"
    var createdAt: Date = Date()
}

struct ActionLog: Codable {
    var identityId: UUID
    var completed: Bool
    var note: String?
}

struct DailyLog: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var actions: [ActionLog]  // one per identity
}

struct AppData: Codable {
    var identities: [Identity]
    var dailyLogs: [DailyLog]

    init(identities: [Identity] = [], dailyLogs: [DailyLog] = []) {
        self.identities = identities
        self.dailyLogs = dailyLogs
    }
}
