import Foundation

struct GroomEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var petName: String
    var product: String
    var result: String
    var date: Date

    init(id: UUID = UUID(), createdAt: Date = Date(), petName: String = "", product: String = "", result: String = "", date: Date = Date()) {
        self.id = id
        self.createdAt = createdAt
        self.petName = petName
        self.product = product
        self.result = result
        self.date = date
    }
}
