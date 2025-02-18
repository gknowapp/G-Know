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
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero
    
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
        NavigationStack {
            ZStack {
                // Bottom layer - Canvas and content
                VStack {
                    if isEditable {
                        Spacer(minLength: UIHelper.relativeHeight(0.17) + UIHelper.relativeHeight(0.04)) // Top toolbar spacing
                        
                        ZStack {
                            // Display the saved drawing as a background image
                            CanvasView(canvasView: $canvasView, drawing: $savedDrawing, isDrawing: $showDrawingCanvas)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.clear)
                            
                            ConnectionsView(
                                connections: connections,
                                genogramData: genogramData,
                                onConnectionTap: handleMarriageConnectionTap
                            )
                            
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
                        
                        Spacer(minLength: UIHelper.screenSize.height * 0.15) // Bottom toolbar spacing
                    }
                }
                
                // Middle layer - Top toolbar
                VStack {
                    if isEditable {
                        // Toolbar content
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
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
                
                if let selectedShape = activeShape {
                    HStack {
                        Button(action: {
                            showNotesPopup = true
                        }) {
                            Text("Notes")
                        }
                        
                    }
                }
                // Top layer - Bottom toolbar
                VStack {
                    Spacer()
                    ZStack {
                        HStack {
                            Rectangle()
                                .frame(width: UIHelper.screenSize.width, height: UIHelper.screenSize.height * 0.15)
                                .foregroundColor(Color("Anti-flash White"))
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
            
            .onAppear {
                // Lock to landscape when view appears
                lockOrientation(.landscape)
            }
            .onDisappear {
                // Remove lock when view disappears
                lockOrientation(.all)
            }
        }
        .navigationBarBackButtonHidden(true) // This hides the default back button
    }
    
    struct ConnectionsView: View {
        let connections: [Connection]
        let genogramData: GenogramData
        let onConnectionTap: (Connection) -> Void
        
        var body: some View {
            ZStack {
                // Marriage Connections
                ForEach(connections.filter { $0.type == .marriage }) { connection in
                    MarriageConnectionView(connection: connection, genogramData: genogramData)
                        .contentShape(Rectangle()) // Make the whole area tappable
                        .onTapGesture {
                            onConnectionTap(connection)
                        }
                }
                
                // Child Connections
                ForEach(connections.filter { $0.type == .child }) { connection in
                    ChildConnectionView(connection: connection,
                                      connections: connections,
                                      genogramData: genogramData)
                }
            }
        }
    }
    
    struct MarriageConnectionView: View {
        let connection: Connection
        let genogramData: GenogramData
        
        var body: some View {
            let start = getBottomCenter(for: connection.startSymbolId, in: genogramData)
            let end = getBottomCenter(for: connection.endSymbolId, in: genogramData)
            
            MarriageConnectionLine(start: start, end: end)
                .stroke(Color("Candace's Couch"), lineWidth: 2)
        }
        
        private func getBottomCenter(for symbolId: UUID, in data: GenogramData) -> CGPoint {
            if let shape = data.genogram.first(where: { $0.id == symbolId }) {
                return CGPoint(
                    x: shape.position.x,
                    y: shape.position.y + (UIHelper.standardIconSize / 2)
                )
            }
            return .zero
        }
    }
    
    struct ChildConnectionView: View {
        let connection: Connection
        let connections: [Connection]
        let genogramData: GenogramData
        
        var body: some View {
            if let parentConnection = connections.first(where: { $0.id == connection.parentConnectionId }) {
                let parentStart = getBottomCenter(for: parentConnection.startSymbolId, in: genogramData)
                let parentEnd = getBottomCenter(for: parentConnection.endSymbolId, in: genogramData)
                let childPoint = getTopCenter(for: connection.endSymbolId, in: genogramData)
                
                // Get all siblings and sort them by their x position
                let siblings = connections.filter { $0.type == .child && $0.parentConnectionId == parentConnection.id }
                    .sorted { (conn1, conn2) -> Bool in
                        let pos1 = getSymbolPosition(for: conn1.endSymbolId, in: genogramData)
                        let pos2 = getSymbolPosition(for: conn2.endSymbolId, in: genogramData)
                        return pos1.x < pos2.x
                    }
                
                let siblingIndex = siblings.firstIndex(where: { $0.id == connection.id }) ?? 0
                let totalSiblings = siblings.count
                
                // Calculate position along marriage line
                let marriageLineLength = parentEnd.x - parentStart.x
                let spacing = marriageLineLength / CGFloat(totalSiblings + 1)
                let startX = parentStart.x + (spacing * CGFloat(siblingIndex + 1))
                
                let connectionPoint = CGPoint(
                    x: startX,
                    y: parentStart.y + 20
                )
                
                ChildConnectionLine(
                    startPoint: connectionPoint,
                    childPoint: childPoint
                )
                .stroke(Color("Candace's Couch"), lineWidth: 2)
            }
        }
        
        // Helper function to get symbol position
        private func getSymbolPosition(for symbolId: UUID, in data: GenogramData) -> CGPoint {
            if let shape = data.genogram.first(where: { $0.id == symbolId }) {
                return shape.position
            }
            return .zero
        }
        
        private func getBottomCenter(for symbolId: UUID, in data: GenogramData) -> CGPoint {
            if let shape = data.genogram.first(where: { $0.id == symbolId }) {
                return CGPoint(
                    x: shape.position.x,
                    y: shape.position.y + (UIHelper.standardIconSize / 2)
                )
            }
            return .zero
        }
        
        private func getTopCenter(for symbolId: UUID, in data: GenogramData) -> CGPoint {
            if let shape = data.genogram.first(where: { $0.id == symbolId }) {
                return CGPoint(
                    x: shape.position.x,
                    y: shape.position.y - (UIHelper.standardIconSize / 2)
                )
            }
            return .zero // Returns (0,0) if shape not found
        }
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
                let marriageConnection = Connection(
                    id: UUID(),
                    start: getBottomCenter(for: firstSymbol.id),
                    end: getBottomCenter(for: shape.id),
                    startSymbolId: firstSymbol.id,
                    endSymbolId: shape.id,
                    type: .marriage
                )
                connections.append(marriageConnection)
            }
            startSymbol = nil
        } else {
            // Start a potential child connection
            startSymbol = shape
        }
    }
    
    // Add a new function to handle tapping on marriage connections
    private func handleMarriageConnectionTap(_ connection: Connection) {
        if let firstSymbol = startSymbol, connection.type == .marriage {
            // Create child connection from the clicked symbol to the marriage line
            let childConnection = Connection(
                id: UUID(),
                start: getTopCenter(for: firstSymbol.id),
                end: connection.parentMiddlePoint ?? .zero,
                startSymbolId: firstSymbol.id, // This is the symbol we clicked first
                endSymbolId: firstSymbol.id, // Using the same symbol ID since we're connecting TO the marriage line
                type: .child,
                parentConnectionId: connection.id
            )
            connections.append(childConnection)
            startSymbol = nil
        }
    }
    
    // Helper function to manage orientation
    private func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }
        
        window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation)) { error in
                print("Failed to update orientation: \(error.localizedDescription)")
            }
        }
        
        // For iPad, we need to set the preferred orientation
        if UIDevice.current.userInterfaceIdiom == .pad {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            
            // Ensure the change has effect
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }

    private func handleIconTap(imageName: String) {
        addIconToGenogram(imageName: imageName)
    }
    
    private func addIconToGenogram(imageName: String) {
        let newShape = GenogramShape(id: UUID(), imageName: imageName, position: CGPoint(x: 100, y: 100))
        genogramData.genogram.append(newShape)
    }
    
    private func moveShape(shape: GenogramShape, newLocation: CGPoint) {
        if let index = genogramData.genogram.firstIndex(where: { $0.id == shape.id }) {
            genogramData.genogram[index].position = newLocation
            updateConnections(for: genogramData.genogram[index])
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
        var parentConnectionId: UUID?
        
        var parentMiddlePoint: CGPoint? {
            guard let start = start, let end = end else { return nil }
            return CGPoint(x: (start.x + end.x) / 2, y: start.y)
        }
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
        let startPoint: CGPoint
        let childPoint: CGPoint
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            // Start from the point on marriage line
            path.move(to: startPoint)
            
            // Calculate the midpoint between start and child
            let midY = startPoint.y + ((childPoint.y - startPoint.y) / 2)
            
            // Draw vertical line to midpoint
            path.addLine(to: CGPoint(x: startPoint.x, y: midY))
            
            // Draw horizontal line to align with child
            path.addLine(to: CGPoint(x: childPoint.x, y: midY))
            
            // Draw final vertical line to child
            path.addLine(to: childPoint)
            
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
