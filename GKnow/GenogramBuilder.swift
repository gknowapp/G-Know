import SwiftUI
import PencilKit

struct GenogramBuilder: View {
    @Binding var genogramData: GenogramData
    @Binding var selectedIcon: String?
    @Binding var isSidePanelVisible: Bool
    @State private var activeShape: GenogramShape? = nil
    @State private var showNotesPopup: Bool = false
    @State private var iconClickCounter: [String: Int] = [:]
    @State private var showPeopleOptions = false
    @State private var showRelationshipOptions = false
    @State private var showSymptomOptions = false
    @State private var showDrawingCanvas: Bool = false // State for showing the drawing canvas
    @State private var canvasView = PKCanvasView() // PencilKit canvas view
    @State private var savedDrawing = PKDrawing() // Stores the drawing to display it after exiting
    
    
    /** Cursor first attempt at creating the function*/
    @State private var isConnectingMode: Bool = false
    @State private var drawingMode: DrawingMode = .none
    @State private var selectedConnection: Connection? = nil // For child connections
    @State private var currentLine: [CGPoint] = []
    @State private var isDrawingLine: Bool = false
    @State private var connections: [Connection] = []
    @State private var startSymbol: GenogramShape? = nil
    @State private var pkDrawing = PKDrawing() // For temporary drawing
    
    enum DrawingMode {
           case none
           case connecting
           case freeform
       }
    enum ConnectionType {
        case marriage
        case child
    }
    
    let isEditable: Bool
    var imageOptions = ["AbortionIcon", "MiscarriageIcon", "MaleDeathIcon", "FemaleDeathIcon"]
    var imageOptionsLabel = ["MaleIcon", "FemaleIcon", "UnknownGenderIcon", "PregnancyIcon"]
    var relationshipOptions = ["MarriageIcon", "EngagedIcon", "CommittedRelationshipIcon", "LegalSeparationIcon", "SeparationInFactIcon"]
    var relationshipOptionsLabel = ["CutoffIcon", "DivorceIcon", "FocusedOnIcon", "NormalIcon", "FocusedOnNegativelyIcon"]
    var symptomOptions = ["MaleADRecoveryIcon", "MaleIllnessRecoveryIcon", "MaleIllnessRecoveryIcon"]
    var symptomOptionsLabel = ["MaleADAbuseIcon", "MaleIllnessIcon", "MaleIllnessRecoveryIcon"]
    
    @Environment(\.dismiss) var dismiss
    //@Binding var isTherapistView: Bool
    @State private var showTherapistView = false
    @State private var navigateToTherapist = false
    //@State private var isExpanded = false

    
    var body: some View {
        ZStack {
            VStack {
                /*Text("Genogram Builder")
                 .font(.largeTitle)
                 .padding()*/
                // ... existing code ...
                
                if isEditable {
                    HStack(alignment: .top) {
                        Spacer()
                        
                        // Main toolbar container
                        HStack(spacing: UIHelper.standardPadding) {
                            // People/Icons Group
                            DisclosureGroup(
                                content: {
                                    
                                        HStack(spacing: UIHelper.standardPadding) {
                                            ForEach(imageOptions, id: \.self) { imageName in
                                                Image(imageName)
                                                    .resizable()
                                                    .frame(width: UIHelper.standardIconSize,
                                                           height: UIHelper.standardIconSize)
                                                    .cornerRadius(UIHelper.standardCornerRadius)
                                                    .onTapGesture {
                                                        handleIconTap(imageName: imageName)
                                                    }
                                            }
                                        }
                                        .padding(.vertical, UIHelper.standardPadding)
                                   
                                },
                                label: {
                                    
                                        HStack(spacing: UIHelper.standardPadding) {
                                            ForEach(imageOptionsLabel, id: \.self) { imageName in
                                                Image(imageName)
                                                    .resizable()
                                                    .frame(width: UIHelper.standardIconSize,
                                                           height: UIHelper.standardIconSize)
                                                    .cornerRadius(UIHelper.standardCornerRadius)
                                                    .onTapGesture {
                                                        handleIconTap(imageName: imageName)
                                                    }
                                            }
                                        }
                                    }
                                
                            )
                            .frame(width: UIHelper.relativeWidth(0.23))
                            .padding(.horizontal, UIHelper.standardPadding)
                            .accentColor(Color("Candace's Couch"))
                            .foregroundStyle(Color("Candace's Couch"))
                            
                            Divider()
                            
                            // Relationships Group
                            DisclosureGroup(
                                content: {
                                    
                                    HStack(spacing: UIHelper.standardPadding) {
                                        ForEach(relationshipOptions, id: \.self) { imageName in
                                            Image(imageName)
                                                .resizable()
                                                .frame(width: UIHelper.standardIconSize,
                                                       height: UIHelper.standardIconSize)
                                                .cornerRadius(UIHelper.standardCornerRadius)
                                                .onTapGesture {
                                                    handleIconTap(imageName: imageName)
                                                }
                                        }
                                    }
                                    .padding(.vertical, UIHelper.standardPadding)
                                    
                                },
                                label: {
                                    
                                        HStack(spacing: UIHelper.standardPadding) {
                                            ForEach(relationshipOptionsLabel, id: \.self) { imageName in
                                                Image(imageName)
                                                    .resizable()
                                                    .frame(width: UIHelper.standardIconSize,
                                                           height: UIHelper.standardIconSize)
                                                    .cornerRadius(UIHelper.standardCornerRadius)
                                                    .onTapGesture {
                                                        handleIconTap(imageName: imageName)
                                                    }
                                            }
                                        }
                                    
                                }
                            )
                            .frame(width: UIHelper.relativeWidth(0.23))
                            .padding(.horizontal, UIHelper.standardPadding)
                            .accentColor(Color("Candace's Couch"))
                            .foregroundStyle(Color("Candace's Couch"))
                            
                            Divider()
                            
                            // Symptoms Group
                            DisclosureGroup(
                                content: {
                                    
                                        HStack(spacing: UIHelper.standardPadding) {
                                            ForEach(symptomOptions, id: \.self) { imageName in
                                                Image(imageName)
                                                    .resizable()
                                                    .frame(width: UIHelper.standardIconSize,
                                                           height: UIHelper.standardIconSize)
                                                    .cornerRadius(UIHelper.standardCornerRadius)
                                                    .onTapGesture {
                                                        handleIconTap(imageName: imageName)
                                                    }
                                            }
                                        }
                                        .padding(.vertical, UIHelper.standardPadding)
                                    
                                },
                                label: {
                                    
                                        HStack(spacing: UIHelper.standardPadding) {
                                            ForEach(symptomOptionsLabel, id: \.self) { imageName in
                                                Image(imageName)
                                                    .resizable()
                                                    .frame(width: UIHelper.standardIconSize,
                                                           height: UIHelper.standardIconSize)
                                                    .cornerRadius(UIHelper.standardCornerRadius)
                                                    .onTapGesture {
                                                        handleIconTap(imageName: imageName)
                                                    }
                                            }
                                        }
                                    }
                                
                            )
                            .frame(width: UIHelper.relativeWidth(0.23))
                            .padding(.horizontal, UIHelper.standardPadding)
                            .accentColor(Color("Candace's Couch"))
                            .foregroundStyle(Color("Candace's Couch"))
                        }
                        .background(Color("Light Green"))
                        .frame(height: UIHelper.relativeHeight(0.17))
                        .clipShape(RoundedRectangle(cornerRadius: UIHelper.standardCornerRadius))
                        .padding(.top, UIHelper.relativeHeight(0.04))
                        //.withStandardShadow()
                        
                        
                        
                        
                        
                        
                        
                        Spacer()
                        /*ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Anti-flash White"))
                                .frame(width: 75, height: 200)
                                .padding(.trailing, 50)
                                .padding(.top, 40)
                                .shadow(radius: 5, x:4, y:2)
                            VStack {
                                // Redo Button
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "arrowshape.turn.up.right.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color("Candace's Couch"))
                                        .padding()
                                        .padding(.top, 35)
                                        .padding(.trailing, 45)
                                }
                                
                                // Undo Button
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "arrowshape.turn.up.left.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color("Candace's Couch"))
                                        .padding()
                                        .padding(.top, 15)
                                        .padding(.trailing, 50)
                                }
                            }
                        }*/
                    }
                    ZStack {
                        // Display the saved drawing as a background image
                        CanvasView(canvasView: $canvasView, drawing: $savedDrawing, isDrawing: $showDrawingCanvas)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)
                        
                        ForEach(genogramData.genogram) { shape in
                                            Image(shape.imageName)
                                                .resizable()
                                                .frame(width: UIHelper.standardIconSize, height: UIHelper.standardIconSize)
                                                .position(x: shape.position.x, y: shape.position.y)
                                                .gesture(
                                                    DragGesture()
                                                        .onChanged { value in
                                                            if isEditable {
                                                                moveShape(shape: shape, newLocation: value.location)
                                                                updateConnections(for: shape)
                                                            }
                                                        }
                                                )
                                                .onTapGesture {
                                                    handleSymbolTap(shape)
                                                }
                                        }
                        
                        // Draw existing connections
                        ForEach(connections) { connection in
                                            switch connection.type {
                                            case .marriage:
                                                MarriageConnectionLine(
                                                    start: getBottomCenter(for: connection.startSymbolId),
                                                    end: getBottomCenter(for: connection.endSymbolId)
                                                )
                                                .stroke(Color("Candace's Couch"), lineWidth: 2)
                                                .contentShape(Rectangle()) // Make the whole area tappable
                                                .onTapGesture {
                                                    if isConnectingMode, let symbol = startSymbol {
                                                        // Create child connection
                                                        createChildConnection(from: connection, to: symbol)
                                                        startSymbol = nil
                                                    }
                                                }
                                            case .child:
                                                if let parentConnection = connections.first(where: { $0.id == connection.parentConnectionId }) {
                                                    ChildConnectionLine(
                                                        parentStart: getBottomCenter(for: parentConnection.startSymbolId),
                                                        parentEnd: getBottomCenter(for: parentConnection.endSymbolId),
                                                        childPosition: getTopCenter(for: connection.endSymbolId)
                                                    )
                                                    .stroke(Color("Candace's Couch"), lineWidth: 2)
                                                }
                                            }
                                        }
                                                
                                                // PencilKit canvas
                                                ConnectingCanvasView(
                                                    canvasView: $canvasView,
                                                    drawing: $pkDrawing,
                                                    drawingMode: $drawingMode,
                                                    onDrawingFinished: handleDrawingFinished,
                                                    findNearbySymbol: findNearbySymbol
                                                )
                                                .opacity(drawingMode != .none ? 1 : 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("White"))
                    
                    Spacer()
                    
                    if let selectedShape = activeShape {
                        HStack {
                            Button(action: {
                                showNotesPopup = true
                            }) {
                                Text("Notes")
                            }
                            
                        }
                    }
                    ZStack {
                        HStack {
                            Rectangle()
                                .frame(width: 1400, height: 74)
                                .foregroundColor(Color("Anti-flash White"))
                            //.ignoresSafeArea()
                                .foregroundStyle(
                                    .shadow(.inner(color: .black, radius: 10, x: 1, y: 4)))
                                .border(Color.black.opacity(0.3), width: 2)
                        }
                        HStack {
                            //NavigationStack{
                            // Button to take you back to patient page
                            HStack{
                                Button(action: { showTherapistView = true
                                    dismiss()
                                    //dismiss() // Dismiss the view
                                    //isTherapistView = true // Update isHome to trigger navigation back home
                                    navigateToTherapist = true
                                }) {
                                    HStack {
                                        Image(systemName: "house.fill")
                                            .resizable()
                                            .frame(width:35, height:30)
                                            .foregroundColor(Color("Candace's Couch"))
                                            .padding(.leading, 40)
                                    }
                                }}
                            
                            HStack {
                                Button(action: {
                                                isConnectingMode.toggle()
                                                startSymbol = nil  // Reset selection when toggling mode
                                            }) {
                                                Image(systemName: isConnectingMode ? "link.circle.fill" : "link.circle")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(Color("Candace's Couch"))
                                            }
                                
                                
                            }
                            //.frame(maxWidth: .infinity, alignment: .leading)
                            //.navigationDestination(isPresented: $showTherapistView) {TherapistView()}}
                            /*NavigationLink(destination: TherapistView(), isActive: $navigateToTherapist) {
                             EmptyView() // Hidden link
                             }*/
                            //}
                            Spacer()
                            // Button to toggle the drawing mode
                            if isEditable {
                                Button(action: {
                                    if showDrawingCanvas {
                                        savedDrawing = canvasView.drawing // Save the current drawing
                                    }
                                    showDrawingCanvas.toggle()
                                }) {
                                    
                                    Image(systemName: showDrawingCanvas ? "xmark.circle" : "pencil")
                                        .resizable()
                                        .frame(width:30, height:30)
                                        .foregroundColor(Color("Candace's Couch"))
                                        .padding(.trailing, 40)
                                }
                            }
                        }
                    }
                }
                
                
                /*ZStack {
                 
                 
                 Spacer()
                 
                 if let selectedShape = activeShape {
                 HStack {
                 Button(action: {
                 showNotesPopup = true
                 }) {
                 Text("Notes")
                 .padding()
                 .background(Color.blue)
                 .foregroundColor(.white)
                 .cornerRadius(10)
                 }
                 
                 if isEditable {
                 Button(action: {
                 deleteActiveShape()
                 }) {
                 Text("Delete")
                 .padding()
                 .background(Color.red)
                 .foregroundColor(.white)
                 .cornerRadius(10)
                 }
                 }
                 }
                 }
                 }*/
                
                
            }
            
            
            
            .padding(.top)
            .sheet(isPresented: $showNotesPopup) {
                if let shape = activeShape {
                    NotesPopupView(shape: Binding(
                        get: {
                            if let index = genogramData.genogram.firstIndex(where: { $0.id == shape.id }) {
                                return genogramData.genogram[index]
                            }
                            return shape
                        },
                        set: { updatedShape in
                            if let index = genogramData.genogram.firstIndex(where: { $0.id == updatedShape.id }) {
                                genogramData.genogram[index] = updatedShape
                            }
                        }
                    ), isEditable: isEditable)
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
            .frame(minWidth: UIHelper.screenSize.width, minHeight: UIHelper.screenSize.height)
            .background(Color("White"))
            
            
            //.presentationSizing(.fitted)
            
            
            .onAppear {
                // Lock to landscape when view appears
                lockOrientation(.landscape)
            }
            .onDisappear {
                // Remove lock when view disappears
                lockOrientation(.all)
            }
        }
       /* .toolbar {
                   ToolbarItem(placement: .primaryAction) {
                       
                   }
               } */
    }
    
    private func getBottomCenter(for symbolId: UUID) -> CGPoint {
            if let shape = genogramData.genogram.first(where: { $0.id == symbolId }) {
                return CGPoint(
                    x: shape.position.x,
                    y: shape.position.y + (UIHelper.standardIconSize / 2)
                )
            }
            return .zero
        }
        
        private func getTopCenter(for symbolId: UUID) -> CGPoint {
            if let shape = genogramData.genogram.first(where: { $0.id == symbolId }) {
                return CGPoint(
                    x: shape.position.x,
                    y: shape.position.y - (UIHelper.standardIconSize / 2)
                )
            }
            return .zero
        }
        
    private func handleSymbolTap(_ shape: GenogramShape) {
            if !isConnectingMode {
                activeShape = shape
                return
            }
            
            if let firstSymbol = startSymbol {
                if firstSymbol.id != shape.id {
                    // Create marriage connection between two symbols
                    createMarriageConnection(from: firstSymbol, to: shape)
                }
                startSymbol = nil
            } else {
                startSymbol = shape
            }
        }
    
    private func createMarriageConnection(from first: GenogramShape, to second: GenogramShape) {
            connections.append(Connection(
                id: UUID(),
                startSymbolId: first.id,
                endSymbolId: second.id,
                type: .marriage
            ))
        }
    
    private func handleMarriageConnection(_ shape: GenogramShape) {
            if startSymbol == nil {
                startSymbol = shape
            } else if startSymbol!.id != shape.id {
                connections.append(Connection(
                    id: UUID(),
                    startSymbolId: startSymbol!.id,
                    endSymbolId: shape.id,
                    type: .marriage
                ))
                startSymbol = nil
            }
        }
    
    private func createChildConnection(from parentConnection: Connection, to childSymbol: GenogramShape) {
            connections.append(Connection(
                id: UUID(),
                startSymbolId: parentConnection.startSymbolId,
                endSymbolId: childSymbol.id,
                type: .child,
                parentConnectionId: parentConnection.id
            ))
        }
        
        private func handleChildConnection(_ shape: GenogramShape) {
            if let parentConnection = selectedConnection {
                connections.append(Connection(
                    id: UUID(),
                    startSymbolId: parentConnection.startSymbolId,
                    endSymbolId: shape.id,
                    type: .child,
                    parentConnectionId: parentConnection.id
                ))
                selectedConnection = nil
            }
        }
    
    
                // Helper function to manage orientation
    private func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
                }
                    
                    // Force immediate rotation if needed
        if orientation == .landscape {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }

        
       
    
    
    private func handleIconTap(imageName: String) {
        /*iconClickCounter[imageName, default: 0] += 1
        if iconClickCounter[imageName] == 1 {
            selectedIcon = imageName
            isSidePanelVisible = true // TODO THIS IS JUST FOR DEMO PURPOSES... LOOK INTO THIS LATER
        } else if iconClickCounter[imageName] == 2 {
            addIconToGenogram(imageName: imageName)
            iconClickCounter[imageName] = 0
            isSidePanelVisible = false
        } */
        
        addIconToGenogram(imageName: imageName)
    }
    
    private func addIconToGenogram(imageName: String) {
        let newShape = GenogramShape(id: UUID(), imageName: imageName, position: CGPoint(x: 100, y: 100))
        genogramData.genogram.append(newShape)
    }
    
    private func moveShape(shape: GenogramShape, newLocation: CGPoint) {
        if let index = genogramData.genogram.firstIndex(where: { $0.id == shape.id }) {
            genogramData.genogram[index].position = newLocation
        }
    }
    
    private func deleteActiveShape() {
        if let activeShape = activeShape, let index = genogramData.genogram.firstIndex(where: { $0.id == activeShape.id }) {
            genogramData.genogram.remove(at: index)
            self.activeShape = nil
        }
    }
    
    private func handleDrawingFinished(startPoint: CGPoint, endPoint: CGPoint) {
            guard drawingMode == .connecting,
                  let startSymbol = findNearbySymbol(at: startPoint),
                  let endSymbol = findNearbySymbol(at: endPoint),
                  startSymbol.id != endSymbol.id else {
                pkDrawing = PKDrawing() // Clear temporary drawing
                return
            }
            
            // Create new connection
        let connection = Connection(
            id: UUID(),
            startSymbolId: startSymbol.id,
            endSymbolId: endSymbol.id,
            type: .marriage  // Add the required type parameter
        )
            connections.append(connection)
            pkDrawing = PKDrawing() // Clear temporary drawing
        }
        
        private func findNearbySymbol(at point: CGPoint) -> GenogramShape? {
            let threshold: CGFloat = UIHelper.standardIconSize
            return genogramData.genogram.first { shape in
                let distance = sqrt(
                    pow(shape.position.x - point.x, 2) +
                    pow(shape.position.y - point.y, 2)
                )
                return distance < threshold
            }
        }
    
   /* private func handleSymbolTapInConnectingMode(_ shape: GenogramShape) {
            if startSymbol == nil {
                // First symbol selection
                startSymbol = shape
            } else if startSymbol!.id != shape.id {
                // Second symbol selection - create connection
                let connection = Connection(
                    id: UUID(),
                    start: startSymbol!.position,
                    end: shape.position,
                    startSymbolId: startSymbol!.id,
                    endSymbolId: shape.id
                )
                connections.append(connection)
                startSymbol = nil  // Reset for next connection
            }
        } */
        
    private func updateConnections(for shape: GenogramShape) {
            connections = connections.map { connection in
                var updatedConnection = connection
                if connection.startSymbolId == shape.id {
                    updatedConnection.start = shape.position
                }
                if connection.endSymbolId == shape.id {
                    updatedConnection.end = shape.position
                }
                return updatedConnection
            }
        }
    
    
    struct Connection: Identifiable {
        let id: UUID
        var start: CGPoint?
        var end: CGPoint?
        let startSymbolId: UUID
        let endSymbolId: UUID
        let type: ConnectionType
        var parentConnectionId: UUID? // For child connections
    }
    
    struct MarriageConnectionLine: Shape {
        let start: CGPoint
        let end: CGPoint
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let spacing: CGFloat = 20 // Vertical spacing for marriage connection
            
            // Start point
            path.move(to: start)
            // Down from start
            path.addLine(to: CGPoint(x: start.x, y: start.y + spacing))
            // Horizontal connection
            path.addLine(to: CGPoint(x: end.x, y: start.y + spacing))
            // Up to end
            path.addLine(to: end)
            
            return path
        }
    }
    
    struct ChildConnectionLine: Shape {
        let parentStart: CGPoint
        let parentEnd: CGPoint
        let childPosition: CGPoint
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let parentMiddleX = (parentStart.x + parentEnd.x) / 2
            let parentY = parentStart.y + 20 // Use same spacing as marriage connection
            
            // Start from parent connection
            path.move(to: CGPoint(x: parentMiddleX, y: parentY))
            // Draw down to child level
            path.addLine(to: CGPoint(x: parentMiddleX, y: childPosition.y))
            // Draw to child
            path.addLine(to: childPosition)
            
            return path
        }
    }

    struct ConnectingCanvasView: UIViewRepresentable {
        @Binding var canvasView: PKCanvasView
        @Binding var drawing: PKDrawing
        @Binding var drawingMode: DrawingMode
        var onDrawingFinished: (CGPoint, CGPoint) -> Void
        var findNearbySymbol: (CGPoint) -> GenogramShape?
        
        func makeUIView(context: Context) -> PKCanvasView {
            canvasView.delegate = context.coordinator
            canvasView.drawing = drawing
            canvasView.tool = PKInkingTool(.pen, color: .systemBlue, width: 2)
            return canvasView
        }
        
        func updateUIView(_ uiView: PKCanvasView, context: Context) {
            uiView.drawing = drawing
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, PKCanvasViewDelegate {
            let parent: ConnectingCanvasView
            var startPoint: CGPoint?
            
            init(_ parent: ConnectingCanvasView) {
                self.parent = parent
            }
            
            func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
                if let stroke = canvasView.drawing.strokes.last {
                            let points = stroke.path.map { $0 }
                            startPoint = CGPoint(x: points[0].location.x, y: points[0].location.y)
                        }
            }
            
            func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
                if let stroke = canvasView.drawing.strokes.last,
                           let startPoint = startPoint {
                            let points = stroke.path.map { $0 }
                            let endPoint = CGPoint(x: points.last?.location.x ?? 0,
                                                 y: points.last?.location.y ?? 0)
                            
                            parent.onDrawingFinished(startPoint, endPoint)
                        }
                        startPoint = nil
            }
        }
    }
    
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
    var position: CGPoint
    var notes: String = ""
}

struct GenogramData {
    var genogram: [GenogramShape]
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

// Add these new structures


struct DemoDisclosureGroups: View {
    let items: [Bookmark] = [.example1, .example2, .example3]
    @State private var flags: [Bool] = [false, false, false]

    var body: some View {
        List {
            ForEach(Array(items.enumerated()), id: \.1.id) { i, group in
                DisclosureGroup(isExpanded: $flags[i]) {
                    ForEach(group.items ?? []) { item in
                        Label(item.name, systemImage: item.icon)
                    }
                } label: {
                    Label(group.name, systemImage: group.icon)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                self.flags[i].toggle()
                            }
                        }
                }
            }
        }
    }
}
struct Bookmark: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var items: [Bookmark]?

    // some example websites
    static let apple = Bookmark(name: "Apple", icon: "1.circle")
    static let bbc = Bookmark(name: "BBC", icon: "square.and.pencil")
    static let swift = Bookmark(name: "Swift", icon: "bolt.fill")
    static let twitter = Bookmark(name: "Twitter", icon: "mic")

    // some example groups
    static let example1 = Bookmark(name: "Favorites", icon: "star", items: [Bookmark.apple, Bookmark.bbc, Bookmark.swift, Bookmark.twitter])
    static let example2 = Bookmark(name: "Recent", icon: "timer", items: [Bookmark.apple, Bookmark.bbc, Bookmark.swift, Bookmark.twitter])
    static let example3 = Bookmark(name: "Recommended", icon: "hand.thumbsup", items: [Bookmark.apple, Bookmark.bbc, Bookmark.swift, Bookmark.twitter])
}
