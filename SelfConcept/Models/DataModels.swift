import Foundation

enum FrequencyType: Codable {
    case perWeek(Int)
    case perMonth(Int)

    func targetFor(days: Int) -> Double {
        switch self {
        case .perWeek(let count):
            return Double(count) * (Double(days) / 7.0)
        case .perMonth(let count):
            return Double(count) * (Double(days) / 30.0)
        }
    }

    var displayString: String {
        switch self {
        case .perWeek(let count):
            return "\(count)x per week"
        case .perMonth(let count):
            return "\(count)x per month"
        }
    }

    enum CodingKeys: String, CodingKey {
        case perWeek, perMonth
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(Int.self, forKey: .perWeek) {
            self = .perWeek(value)
        } else if let value = try container.decodeIfPresent(Int.self, forKey: .perMonth) {
            self = .perMonth(value)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid FrequencyType"
                )
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .perWeek(let count):
            try container.encode(count, forKey: .perWeek)
        case .perMonth(let count):
            try container.encode(count, forKey: .perMonth)
        }
    }
}

struct Identity: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String           // "I'm fit"
    var action: String         // "gym checkin"
    var frequency: FrequencyType  // "3x per week" or "4x per month"
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
