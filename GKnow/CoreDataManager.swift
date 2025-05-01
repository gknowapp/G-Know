import CoreData
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "GKnow")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Patient Operations
    
    func createPatient(name: String) -> Patient {
        let patient = Patient(context: container.viewContext)
        patient.id = UUID()
        patient.name = name
        patient.createdAt = Date()
        saveContext()
        return patient
    }
    
    func fetchPatients() -> [Patient] {
        let request: NSFetchRequest<Patient> = Patient.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Patient.createdAt, ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching patients: \(error)")
            return []
        }
    }
    
    // MARK: - Genogram Operations
    
    func createGenogram(for patient: Patient) -> Genogram {
        let genogram = Genogram(context: container.viewContext)
        genogram.id = UUID()
        genogram.createdAt = Date()
        genogram.lastModified = Date()
        genogram.patient = patient
        saveContext()
        return genogram
    }
    
    func fetchGenograms(for patient: Patient) -> [Genogram] {
        let request: NSFetchRequest<Genogram> = Genogram.fetchRequest()
        request.predicate = NSPredicate(format: "patient == %@", patient)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Genogram.lastModified, ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching genograms: \(error)")
            return []
        }
    }
    
    // MARK: - Shape Operations
    
    func createShape(in genogram: Genogram, imageName: String, position: CGPoint) -> GenogramShape {
        let shape = GenogramShape(context: container.viewContext)
        shape.id = UUID()
        shape.imageName = imageName
        shape.positionX = position.x
        shape.positionY = position.y
        shape.genogram = genogram
        saveContext()
        return shape
    }
    
    func updateShape(_ shape: GenogramShape, position: CGPoint) {
        shape.positionX = position.x
        shape.positionY = position.y
        saveContext()
    }
    
    // MARK: - Connection Operations
    
    func createConnection(in genogram: Genogram, type: String, startSymbolId: UUID, endSymbolId: UUID, parentConnectionId: UUID? = nil) -> Connection {
        let connection = Connection(context: container.viewContext)
        connection.id = UUID()
        connection.connectionType = type
        connection.startSymbolId = startSymbolId
        connection.endSymbolId = endSymbolId
        connection.parentConnectionId = parentConnectionId
        connection.genogram = genogram
        saveContext()
        return connection
    }
    
    // MARK: - Drawing Operations
    
    func saveDrawing(for genogram: Genogram, drawing: PKDrawing) {
        let drawingData = Drawing(context: container.viewContext)
        drawingData.id = UUID()
        drawingData.data = try? NSKeyedArchiver.archivedData(withRootObject: drawing, requiringSecureCoding: false)
        drawingData.genogram = genogram
        saveContext()
    }
    
    func loadDrawing(for genogram: Genogram) -> PKDrawing? {
        guard let drawingData = genogram.drawing?.data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: PKDrawing.self, from: drawingData)
    }
    
    // MARK: - Context Operations
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
        saveContext()
    }
} 