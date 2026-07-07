import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [GroomEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall on first launch.
    let freeLimit = 25

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("groomkit_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < freeLimit
    }

    func add(_ entry: GroomEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: GroomEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: GroomEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([GroomEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static var seedData: [GroomEntry] {
        [
        GroomEntry(petName: "Pet Name 1", product: "Product Used 1", result: "Result 1", date: Date().addingTimeInterval(-86400)),
        GroomEntry(petName: "Pet Name 2", product: "Product Used 2", result: "Result 2", date: Date().addingTimeInterval(-172800)),
        GroomEntry(petName: "Pet Name 3", product: "Product Used 3", result: "Result 3", date: Date().addingTimeInterval(-259200)),
        GroomEntry(petName: "Pet Name 4", product: "Product Used 4", result: "Result 4", date: Date().addingTimeInterval(-345600)),
        GroomEntry(petName: "Pet Name 5", product: "Product Used 5", result: "Result 5", date: Date().addingTimeInterval(-432000))
        ]
    }
}
