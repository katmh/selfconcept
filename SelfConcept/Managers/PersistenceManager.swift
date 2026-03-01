import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()

    private let fileName = "selfconcept_data.json"

    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var fileURL: URL {
        documentsURL.appendingPathComponent(fileName)
    }

    func save(_ appData: AppData) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(appData)
        try data.write(to: fileURL, options: .atomic)
    }

    func load() -> AppData {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let data = try? Data(contentsOf: fileURL) else {
            return AppData()
        }

        guard let appData = try? decoder.decode(AppData.self, from: data) else {
            return AppData()
        }

        return appData
    }
}
