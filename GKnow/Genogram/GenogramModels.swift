// GenogramModels.swift
import SwiftUI
/*
// Model to represent the shape with an image and notes
struct GenogramShape: Identifiable, Codable {
    var id: UUID
    var imageName: String
    var position: CGPoint
    var notes: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case imageName
        case positionX
        case positionY
        case notes
    }

    init(id: UUID = UUID(), imageName: String, position: CGPoint, notes: String = "") {
        self.id = id
        self.imageName = imageName
        self.position = position
        self.notes = notes
    }

    // Decodable initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageName = try container.decode(String.self, forKey: .imageName)
        notes = try container.decode(String.self, forKey: .notes)
        let positionX = try container.decode(CGFloat.self, forKey: .positionX)
        let positionY = try container.decode(CGFloat.self, forKey: .positionY)
        position = CGPoint(x: positionX, y: positionY)
    }

    // Encodable method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(notes, forKey: .notes)
        try container.encode(position.x, forKey: .positionX)
        try container.encode(position.y, forKey: .positionY)
    }
}
*/
