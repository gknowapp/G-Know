import SwiftUI
import PencilKit
import UIKit
import CoreData

struct GenogramBuilder: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var genogram: Genogram
    @Binding var selectedIcon: String?
    @Binding var isSidePanelVisible: Bool
    @State private var activeShape: GenogramShape? = nil
    @State private var showNotesPopup: Bool = false
    @State private var showPeopleOptions = false
    @State private var showRelationshipOptions = false
    @State private var showSymptomOptions = false
    @State private var showDrawingCanvas: Bool = false
    @State private var canvasView = PKCanvasView()
    @State private var savedDrawing = PKDrawing()
    
    var patientName: String
    
    @State private var isConnectingMode: Bool = false
    @State private var drawingMode: DrawingMode = .none
    @State private var selectedConnection: Connection? = nil
    @State private var currentLine: [CGPoint] = []
    @State private var isDrawingLine: Bool = false
    @State private var startSymbol: GenogramShape? = nil
    @State private var pkDrawing = PKDrawing()
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero
    
    @State private var selectedShapeId: UUID? = nil
    @State private var hasGeneratedTemplate: Bool = false
    @State private var selectedConnectionType: ConnectionType = .marriage
    
    enum DrawingMode {
        case none
        case connecting
        case freeform
    }
    
    let isEditable: Bool
    var imageOptions = ["Male", "Female", "Pregnancy", "Abortion", "Miscarriage", "Unknown Gender"]
    var relationshipOptions = ["Child", "Marriage", "Focused On", "Abuse", "Conflict", "Affair", "Engaged", "Dating", "Harmony", "Friendship", "Fusion"]
    var symptomOptions = ["Male AD Recovery", "Male Illness Recovery"]
    
    @Environment(\.dismiss) var dismiss
    @State private var showTherapistView = false
    @State private var navigateToTherapist = false
    @State private var navigateToLearningLibrary = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Bottom layer - Canvas and content
                VStack(spacing: 0) {
                    if isEditable {
                        ZStack {
                            // Display the saved drawing as a background image
                            CanvasView(canvasView: $canvasView, drawing: $savedDrawing, isDrawing: $showDrawingCanvas)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.clear)
                                .border(Color("Dark Green"))
                            
                            ConnectionsView(
                                genogram: genogram,
                                onConnectionTap: handleMarriageConnectionTap
                            )
                            
                            ForEach(genogram.shapes?.allObjects as? [GenogramShape] ?? []) { shape in
                                ZStack {
                                    if isConnectingMode && (selectedShapeId == shape.id || startSymbol?.id == shape.id) {
                                        Circle()
                                            .stroke(Color("Dark Green"), lineWidth: 2)
                                            .frame(width: UIHelper.standardIconSize + 20, height: UIHelper.standardIconSize + 20)
                                    }
                                    
                                    Image(shape.imageName ?? "")
                                        .resizable()
                                        .frame(width: UIHelper.standardIconSize, height: UIHelper.standardIconSize)
                                }
                                .position(x: shape.positionX, y: shape.positionY)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if isEditable {
                                                shape.positionX = value.location.x
                                                shape.positionY = value.location.y
                                                updateConnections(for: shape)
                                            }
                                        }
                                )
                                .onTapGesture {
                                    handleSymbolTap(shape)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("White"))
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        let delta = value / lastScale
                                        lastScale = value
                                        scale *= delta
                                        scale = min(max(scale, 0.5), 3.0)
                                    }
                                    .onEnded { _ in
                                        lastScale = 1.0
                                    },
                                DragGesture()
                                    .onChanged { value in
                                        let delta = CGSize(
                                            width: value.translation.width - lastOffset.width,
                                            height: value.translation.height - lastOffset.height
                                        )
                                        offset = CGSize(
                                            width: offset.width + delta.width,
                                            height: offset.height + delta.height
                                        )
                                        lastOffset = value.translation
                                    }
                                    .onEnded { _ in
                                        lastOffset = .zero
                                    }
                            )
                        )
                        .onTapGesture(count: 2) {
                            withAnimation(.spring()) {
                                scale = 1.0
                                offset = .zero
                            }
                        }
                    }
                }
                
                // Middle layer - Top toolbar
                VStack {
                    if isEditable {
                        HStack(alignment: .top) {
                            Spacer()
                            
                            TopToolbarView(
                                imageOptions: imageOptions,
                                relationshipOptions: relationshipOptions,
                                symptomOptions: symptomOptions,
                                onIconTap: handleIconTap,
                                isConnectingMode: isConnectingMode,
                                selectedIcon: selectedIcon,
                                dismiss: dismiss,
                                showTherapistView: $showTherapistView,
                                navigateToTherapist: $navigateToTherapist,
                                patientName: patientName
                            )
                            .padding(UIHelper.relativeHeight(0.04))
                            .background(Color("Anti-flash White"))
                            .frame(height: UIHelper.relativeHeight(0.17))
                            .clipShape(RoundedRectangle(cornerRadius: UIHelper.standardCornerRadius))
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(.top)
            .sheet(isPresented: $showNotesPopup) {
                if let shape = activeShape {
                    GenogramSymbolNotes(shape: shape)
                }
            }
            .sheet(isPresented: $isSidePanelVisible) {
                if let selectedIcon = selectedIcon {
                    SidePanelView(
                        iconName: selectedIcon,
                        description: "\(selectedIcon) description",
                        onClose: {
                            isSidePanelVisible = false
                        }
                    )
                }
            }
            .frame(minWidth: UIHelper.cachedScreenSize.width, minHeight: UIHelper.cachedScreenSize.height)
            .background(Color("White"))
            .onAppear {
                if genogram.shapes?.count == 0 {
                    generateTemplate()
                }
                
                // Load saved drawing if it exists
                if let savedDrawing = CoreDataManager.shared.loadDrawing(for: genogram) {
                    self.savedDrawing = savedDrawing
                    canvasView.drawing = savedDrawing
                }
            }
            .onDisappear {
                // Save the current drawing
                CoreDataManager.shared.saveDrawing(for: genogram, drawing: canvasView.drawing)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Helper Methods
    
    private func handleSymbolTap(_ shape: GenogramShape) {
        if !isConnectingMode {
            activeShape = shape
            return
        }
        
        if let firstSymbol = startSymbol {
            if firstSymbol.id != shape.id {
                // Create connection between two symbols
                let connection = CoreDataManager.shared.createConnection(
                    in: genogram,
                    type: selectedConnectionType.rawValue,
                    startSymbolId: firstSymbol.id!,
                    endSymbolId: shape.id!,
                    parentConnectionId: nil
                )
                genogram.addToConnections(connection)
            }
            startSymbol = nil
            selectedShapeId = nil
        } else {
            startSymbol = shape
            selectedShapeId = shape.id
        }
    }
    
    private func handleMarriageConnectionTap(_ connection: Connection) {
        if connection.connectionType == ConnectionType.marriage.rawValue {
            if let firstSymbol = startSymbol {
                let childConnection = CoreDataManager.shared.createConnection(
                    in: genogram,
                    type: ConnectionType.child.rawValue,
                    startSymbolId: connection.startSymbolId!,
                    endSymbolId: firstSymbol.id!,
                    parentConnectionId: connection.id
                )
                genogram.addToConnections(childConnection)
                startSymbol = nil
                selectedShapeId = nil
            }
        }
    }
    
    private func updateConnections(for shape: GenogramShape) {
        // Update any connections related to this shape
        if let connections = genogram.connections?.allObjects as? [Connection] {
            for connection in connections {
                if connection.startSymbolId == shape.id {
                    // Update start position
                }
                if connection.endSymbolId == shape.id {
                    // Update end position
                }
            }
        }
    }
    
    private func handleIconTap(imageName: String) {
        if relationshipOptions.contains(imageName) {
            isConnectingMode = true
            selectedConnectionType = getConnectionType(for: imageName)
            selectedIcon = imageName
        } else {
            addIconToGenogram(imageName: imageName)
        }
    }
    
    private func addIconToGenogram(imageName: String) {
        let visibleCenterX = (UIHelper.cachedScreenSize.width / 2 - offset.width) / scale
        let visibleCenterY = (UIHelper.cachedScreenSize.height / 2 - offset.height) / scale
        
        let shape = CoreDataManager.shared.createShape(
            in: genogram,
            imageName: imageName,
            position: CGPoint(x: visibleCenterX, y: visibleCenterY)
        )
        genogram.addToShapes(shape)
    }
    
    private func getConnectionType(for relationshipImage: String) -> ConnectionType {
        switch relationshipImage {
        case "Marriage": return .marriage
        case "Harmony": return .harmony
        case "Friendship": return .friendship
        case "Divorce": return .divorce
        case "Fusion": return .fusion
        case "Abuse": return .abuse
        case "Focused On": return .focus
        case "Engaged": return .dating
        case "Affair": return .affair
        case "Child": return .child
        case "Conflict": return .conflict
        default: return .child
        }
    }
    
    private func generateTemplate() {
        guard !hasGeneratedTemplate else { return }
        
        let baseSpacing: CGFloat = 100
        let startY: CGFloat = 200
        let startX: CGFloat = UIHelper.cachedScreenSize.width / 4
        
        // First generation (4 pairs)
        let gen1Symbols = [
            ("Male", CGPoint(x: startX, y: startY)),
            ("Female", CGPoint(x: startX + baseSpacing, y: startY)),
            ("Male", CGPoint(x: startX + baseSpacing * 2.5, y: startY)),
            ("Female", CGPoint(x: startX + baseSpacing * 3.5, y: startY)),
            ("Male", CGPoint(x: startX + baseSpacing * 5, y: startY)),
            ("Female", CGPoint(x: startX + baseSpacing * 6, y: startY)),
            ("Male", CGPoint(x: startX + baseSpacing * 7.5, y: startY)),
            ("Female", CGPoint(x: startX + baseSpacing * 8.5, y: startY))
        ]
        
        // Create shapes and store their IDs
        var symbolIds: [[UUID]] = [[],[],[]]
        
        // Add first generation
        for (icon, position) in gen1Symbols {
            let shape = CoreDataManager.shared.createShape(in: genogram, imageName: icon, position: position)
            genogram.addToShapes(shape)
            symbolIds[0].append(shape.id!)
        }
        
        // Create marriage connections for first generation
        for i in stride(from: 0, to: symbolIds[0].count, by: 2) {
            let connection = CoreDataManager.shared.createConnection(
                in: genogram,
                type: ConnectionType.marriage.rawValue,
                startSymbolId: symbolIds[0][i],
                endSymbolId: symbolIds[0][i + 1]
            )
            genogram.addToConnections(connection)
        }
        
        // Mark template as generated
        hasGeneratedTemplate = true
    }
}

// MARK: - Supporting Views

struct ConnectionsView: View {
    @ObservedObject var genogram: Genogram
    let onConnectionTap: (Connection) -> Void
    
    var body: some View {
        ZStack {
            if let connections = genogram.connections?.allObjects as? [Connection] {
                ForEach(connections) { connection in
                    switch connection.connectionType {
                    case ConnectionType.marriage.rawValue:
                        MarriageConnectionLine(start: getBottomCenter(for: connection.startSymbolId!),
                                             end: getBottomCenter(for: connection.endSymbolId!))
                            .stroke(Color("Candace's Couch"), lineWidth: 2)
                            .onTapGesture {
                                onConnectionTap(connection)
                            }
                    // Add other connection types here
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
    
    private func getBottomCenter(for symbolId: UUID) -> CGPoint {
        if let shape = genogram.shapes?.first(where: { ($0 as? GenogramShape)?.id == symbolId }) as? GenogramShape {
            return CGPoint(x: shape.positionX, y: shape.positionY + (UIHelper.standardIconSize / 2) - 5)
        }
        return .zero
    }
}

struct GenogramSymbolNotes: View {
    @ObservedObject var shape: GenogramShape
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notes")) {
                    TextEditor(text: Binding(
                        get: { shape.notes ?? "" },
                        set: { shape.notes = $0 }
                    ))
                    .frame(height: 200)
                }
            }
            .navigationTitle("Edit Notes")
            .navigationBarItems(trailing: Button("Done") {
                try? viewContext.save()
            })
        }
    }
}

// MARK: - Connection Types

enum ConnectionType: String {
    case marriage
    case harmony
    case friendship
    case divorce
    case fusion
    case abuse
    case focus
    case dating
    case affair
    case child
    case conflict
}

// A separate view to handle the PencilKit canvas
struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var drawing: PKDrawing
    @Binding var isDrawing: Bool

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = UIColor.clear
        canvasView.drawing = drawing // Load the saved drawing
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if !isDrawing {
            // Update the saved drawing if exiting drawing mode
            DispatchQueue.main.async {drawing = uiView.drawing}
            
            // ^Testing something
        }
    }
}

// Model to represent each shape with an image and notes
struct GenogramShape: Identifiable {
    var id: UUID
    var imageName: String
    var personName: String = ""
    var positionX: CGFloat
    var positionY: CGFloat
    var notes: String = ""
}

struct GenogramData {
    var genogram: [GenogramShape]
    var connections: [Connection]
}

// View for editing notes for a selected shape in the genogram
struct NotesPopupView: View {
    @Binding var shape: GenogramShape
    var isEditable: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notes")) {
                    if isEditable {
                        TextEditor(text: $shape.notes)
                            .frame(height: 200)
                    } else {
                        Text(shape.notes)
                            .frame(height: 200)
                    }
                }
            }
            .navigationTitle("Edit Notes")
            .navigationBarItems(trailing: Button("Done") {
                // Handle dismiss
            })
        }
    }
}

struct TopToolbarView: View {
    let imageOptions: [String]
    let relationshipOptions: [String]
    let symptomOptions: [String]
    let onIconTap: (String) -> Void
    let isConnectingMode: Bool
    let selectedIcon: String?
    var dismiss: DismissAction
    @Binding var showTherapistView: Bool
    @Binding var navigateToTherapist: Bool
    let patientName: String
    
    var body: some View {
        HStack(spacing: 0) {
            // Left side - Home and User info
            HStack(spacing: 15) {
                Button(action: {
                    showTherapistView = true
                    dismiss()
                    navigateToTherapist = true
                }) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("Candace's Couch"))
                }
                
                
                    NavigationLink(destination: LearningLibraryView()
                        .navigationBarBackButtonHidden(false)
                        .navigationBarTitleDisplayMode(.inline)) {
                        Image(systemName: "book.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color("Candace's Couch"))
                    }
                    
                    .navigationBarBackButtonHidden(false)
                
                
                
                Text(patientName)
                    .foregroundColor(.black)
                    .font(.headline)
                
                /*Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 20, height: 25)
                    .foregroundColor(Color("Candace's Couch"))
                
                Image(systemName: "bookmark")
                    .resizable()
                    .frame(width: 15, height: 25)
                    .foregroundColor(Color("Candace's Couch")) */
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 30)
            
            // Gender Section
            ScrollView(.horizontal) {
                HStack(spacing: UIHelper.standardPadding) {
                    ForEach(imageOptions, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .frame(width: UIHelper.standardIconSize, height: UIHelper.standardIconSize)
                            .onTapGesture {
                                onIconTap(imageName)
                            }
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 30)
            
            // Relationships Section
            
            ScrollView(.horizontal) {
                HStack(spacing: UIHelper.standardPadding) {
                    ForEach(relationshipOptions, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .frame(width: UIHelper.standardIconSize, height: UIHelper.standardIconSize)
                            .overlay(
                                RoundedRectangle(cornerRadius: UIHelper.standardCornerRadius)
                                    .stroke(isConnectingMode && selectedIcon == imageName ?
                                            Color("Dark Green") : Color.clear,
                                            lineWidth: 2)
                            )
                            .onTapGesture {
                                onIconTap(imageName)
                            }
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 30)
            
            // Symptoms Section
            /*ScrollView(.horizontal) {
                HStack(spacing: UIHelper.standardPadding) {
                    ForEach(symptomOptions, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .frame(width: UIHelper.standardIconSize, height: UIHelper.standardIconSize)
                            .onTapGesture {
                                onIconTap(imageName)
                            }
                    }
                }
            }
            .padding(.horizontal)
            */
            Divider()
                .frame(height: 30)
            
            // Right side - Undo, Redo, Edit, Delete
            HStack(spacing: 15) {
                Button(action: {
                    // Undo action
                }) {
                    Image(systemName: "arrow.uturn.backward")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("Candace's Couch"))
                }
                
                Button(action: {
                    // Redo action
                }) {
                    Image(systemName: "arrow.uturn.forward")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("Candace's Couch"))
                }
                
                Button(action: {
                    // Edit action
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("Candace's Couch"))
                }
                
                Button(action: {
                    // Delete action
                }) {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("Candace's Couch"))
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
        .background(Color("Anti-flash White"))
    }
}

