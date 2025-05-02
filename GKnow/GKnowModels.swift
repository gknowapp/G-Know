//
//  GKnowModels.swift
//  GKnow
//
//  Created by Curt Leonard on 5/1/25.

import Foundation
import SwiftData
import PencilKit
import SwiftUI

// Duplicate of ConnectionType enum from ConnectionShapes.swift
enum ConnectionType: String, Codable {
    case marriage = "marriage"
    case child = "child"
    case abuse = "abuse"
    case harmony = "harmony"
    case friendship = "friendship"
    case fusion = "fusion"
    case divorce = "divorce"
    case focus = "focus"
    case dating = "dating"
    case affair = "affair"
    case engaged = "engaged"
    case conflict = "conflict"
}

@Model
class Patient {
    @Attribute(.unique) var id = UUID()
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var dob: Date?
    var birthOrder: [String]?
    var role: [String]?
    
    
    init(firstName: String? = nil, middleName: String? = nil, lastName: String? = nil, dob: Date? = nil, birthOrder: [String]? = nil, role: [String]? = nil) {
        
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.dob = dob
        self.birthOrder = birthOrder
        self.role = role
    }
}

@Model
class GenogramShape: Identifiable {
    @Attribute(.unique) var id = UUID()
    var idString: String
    var imageName: String = ""
    var personName: String = ""
    var positionX: Double = 0
    var positionY: Double = 0
    var notes: String = ""
    
    var position: CGPoint {
        get {
            return CGPoint(x: positionX, y: positionY)
        }
        set {
            positionX = newValue.x
            positionY = newValue.y
        }
    }
    
    init(id: UUID = UUID(), imageName: String = "", personName: String = "", position: CGPoint = .zero, notes: String = "") {
        self.id = id
        self.idString = id.uuidString
        self.imageName = imageName
        self.personName = personName
        self.positionX = position.x
        self.positionY = position.y
        self.notes = notes
    }
}

@Model
class Connection: Identifiable {
    @Attribute(.unique) var id = UUID()
    var startSymbolIdString: String = UUID().uuidString
    var endSymbolIdString: String = UUID().uuidString
    var typeString: String = ""
    var parentConnectionIdString: String?
    var startX: Double?
    var startY: Double?
    var endX: Double?
    var endY: Double?
    
    var startSymbolId: UUID {
        get { UUID(uuidString: startSymbolIdString) ?? UUID() }
        set { startSymbolIdString = newValue.uuidString }
    }
    
    var endSymbolId: UUID {
        get { UUID(uuidString: endSymbolIdString) ?? UUID() }
        set { endSymbolIdString = newValue.uuidString }
    }
    
    var parentConnectionId: UUID? {
        get { parentConnectionIdString.flatMap { UUID(uuidString: $0) } }
        set { parentConnectionIdString = newValue?.uuidString }
    }
    
    var type: ConnectionType {
        get {
            return ConnectionType(rawValue: typeString) ?? .marriage
        }
        set {
            typeString = newValue.rawValue
        }
    }
    
    var start: CGPoint? {
        get {
            guard let startX = startX, let startY = startY else { return nil }
            return CGPoint(x: startX, y: startY)
        }
        set {
            if let newValue = newValue {
                startX = newValue.x
                startY = newValue.y
            } else {
                startX = nil
                startY = nil
            }
        }
    }
    
    var end: CGPoint? {
        get {
            guard let endX = endX, let endY = endY else { return nil }
            return CGPoint(x: endX, y: endY)
        }
        set {
            if let newValue = newValue {
                endX = newValue.x
                endY = newValue.y
            } else {
                endX = nil
                endY = nil
            }
        }
    }
    
    var parentMiddlePoint: CGPoint? {
        guard let start = start, let end = end else { return nil }
        return CGPoint(x: (start.x + end.x) / 2, y: start.y)
    }
    
    // Initialize from ConnectionType enum
    init(id: UUID = UUID(), startSymbolId: UUID, endSymbolId: UUID, type: ConnectionType, parentConnectionId: UUID? = nil, start: CGPoint? = nil, end: CGPoint? = nil) {
        self.id = id
        self.startSymbolIdString = startSymbolId.uuidString
        self.endSymbolIdString = endSymbolId.uuidString
        self.typeString = type.rawValue
        self.parentConnectionIdString = parentConnectionId?.uuidString
        self.start = start
        self.end = end
    }
    
    // Convenience initializer with string type
    init(id: UUID = UUID(), startSymbolId: UUID, endSymbolId: UUID, typeString: String, parentConnectionId: UUID? = nil, start: CGPoint? = nil, end: CGPoint? = nil) {
        self.id = id
        self.startSymbolIdString = startSymbolId.uuidString
        self.endSymbolIdString = endSymbolId.uuidString
        self.typeString = typeString
        self.parentConnectionIdString = parentConnectionId?.uuidString
        self.start = start
        self.end = end
    }
}
