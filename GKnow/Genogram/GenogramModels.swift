// GenogramModels.swift
import SwiftUI
import SwiftData

// Add extension to access shared model context
extension ModelContext {
    static var shared: ModelContext {
        let container = try! ModelContainer(for: Patient.self, GenogramShape.self, Connection.self, PatientGenogram.self)
        return container.mainContext
    }
}

// Model to represent each shape with an image and notes
@Model
class GenogramShape {
    @Attribute(.unique) var id = UUID()
    var imageName: String
    var personName: String = ""
    var positionX: Double
    var positionY: Double
    var notes: String = ""
    var patient: Patient?
    
    var position: CGPoint {
        get { CGPoint(x: positionX, y: positionY) }
        set {
            positionX = newValue.x
            positionY = newValue.y
        }
    }
    
    init(id: UUID = UUID(), imageName: String, personName: String = "", position: CGPoint, notes: String = "", patient: Patient? = nil) {
        self.id = id
        self.imageName = imageName
        self.personName = personName
        self.positionX = position.x
        self.positionY = position.y
        self.notes = notes
        self.patient = patient
    }
}

// Connection types enum
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

// Model to represent connections between shapes
@Model
class Connection {
    @Attribute(.unique) var id = UUID()
    var startShapeId: UUID
    var endShapeId: UUID
    var connectionType: String // Store as String since enums aren't directly supported in SwiftData
    var startX: Double?
    var startY: Double?
    var endX: Double?
    var endY: Double?
    var parentConnectionId: UUID?
    var patient: Patient?
    
    var type: ConnectionType {
        get { ConnectionType(rawValue: connectionType) ?? .marriage }
        set { connectionType = newValue.rawValue }
    }
    
    var start: CGPoint? {
        get {
            if let startX = startX, let startY = startY {
                return CGPoint(x: startX, y: startY)
            }
            return nil
        }
        set {
            if let newValue = newValue {
                startX = newValue.x
                startY = newValue.y
            }
        }
    }
    
    var end: CGPoint? {
        get {
            if let endX = endX, let endY = endY {
                return CGPoint(x: endX, y: endY)
            }
            return nil
        }
        set {
            if let newValue = newValue {
                endX = newValue.x
                endY = newValue.y
            }
        }
    }
    
    var parentMiddlePoint: CGPoint? {
        guard let start = start, let end = end else { return nil }
        return CGPoint(x: (start.x + end.x) / 2, y: start.y)
    }
    
    init(id: UUID = UUID(), start: CGPoint? = nil, end: CGPoint? = nil, 
         startShapeId: UUID, endShapeId: UUID, type: ConnectionType, 
         parentConnectionId: UUID? = nil, patient: Patient? = nil) {
        self.id = id
        self.startShapeId = startShapeId
        self.endShapeId = endShapeId
        self.connectionType = type.rawValue
        self.parentConnectionId = parentConnectionId
        self.patient = patient
        
        if let start = start {
            self.startX = start.x
            self.startY = start.y
        }
        
        if let end = end {
            self.endX = end.x
            self.endY = end.y
        }
    }
}

// Class to wrap all genogram data for a patient
@Model
class PatientGenogram {
    @Attribute(.unique) var id = UUID()
    @Relationship(deleteRule: .cascade) var shapes: [GenogramShape] = []
    @Relationship(deleteRule: .cascade) var connections: [Connection] = []
    var patient: Patient?
    
    init(id: UUID = UUID(), shapes: [GenogramShape] = [], connections: [Connection] = [], patient: Patient? = nil) {
        self.id = id
        self.shapes = shapes
        self.connections = connections
        self.patient = patient
    }
}

// Extension for Patient class to add genogram relationship
extension Patient {
    // This would normally be part of the Patient model, but we're adding it as an extension
    // to keep the separation of concerns
    var genogram: PatientGenogram? {
        get {
            let descriptor = FetchDescriptor<PatientGenogram>(predicate: #Predicate { $0.patient?.id == self.id })
            let modelContext = ModelContext.shared
            let genograms = try? modelContext.fetch(descriptor)
            return genograms?.first
        }
    }
    
    // Method to create a new genogram for this patient
    func createGenogram() -> PatientGenogram {
        let newGenogram = PatientGenogram(patient: self)
        let modelContext = ModelContext.shared
        modelContext.insert(newGenogram)
        return newGenogram
    }
    
    // Method to get or create a genogram for this patient
    func getOrCreateGenogram() -> PatientGenogram {
        if let existingGenogram = genogram {
            return existingGenogram
        } else {
            return createGenogram()
        }
    }
}

// Temporary struct for backward compatibility with existing code
struct GenogramData {
    var genogram: [GenogramShape]
    var connections: [Connection]
    
    init(genogram: [GenogramShape], connections: [Connection]) {
        self.genogram = genogram
        self.connections = connections
    }
    
    // Convert to/from PatientGenogram
    static func from(patientGenogram: PatientGenogram) -> GenogramData {
        return GenogramData(genogram: patientGenogram.shapes, connections: patientGenogram.connections)
    }
    
    func toPatientGenogram(for patient: Patient) -> PatientGenogram {
        let newGenogram = PatientGenogram(shapes: genogram, connections: connections, patient: patient)
        return newGenogram
    }
} 