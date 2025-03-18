import SwiftUI
import PencilKit


struct GenogramBuilder: View {
    @Binding var genogramData: GenogramData
    @Binding var selectedIcon: String?
    @Binding var isSidePanelVisible: Bool
    @State private var activeShape: GenogramShape? = nil
    @State private var showNotesPopup: Bool = false
    @State private var iconClickCounter: [String: Int] = [:] // dont think i need this
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
    @State private var startSymbol: GenogramShape? = nil
    @State private var pkDrawing = PKDrawing() // For temporary drawing
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero
    
    @State private var selectedShapeId: UUID? = nil
    
    @State private var hasGeneratedTemplate: Bool = false
    
    @State private var selectedConnectionType: Connection.ConnectionType = .marriage
    
    enum DrawingMode {
           case none
           case connecting
           case freeform
       }
   
    
    let isEditable: Bool
    var imageOptions = ["Abortion", "Miscarriage", "Male Death", "Female Death"]
    var imageOptionsLabel = ["Male", "Female", "Unknown Gender", "Pregnancy"]
    var relationshipOptions = ["Marriage", "Engaged", "Committed Relationship", "Legal Separation", "Separation In Fact"]
    var relationshipOptionsLabel = ["Cutoff", "Divorce", "Focused On", "Normal", "Abuse"]
    var symptomOptions = ["Male AD Recovery", "Male Illness Recovery", "Male Illness Recovery"]
    var symptomOptionsLabel = ["Male AD Abuse", "Male Illness", "Male Illness Recovery"]
    
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
                                .border(Color("Dark Green"))
                            
                            ConnectionsView(
                                genogramData: genogramData,
                                onConnectionTap: handleMarriageConnectionTap
                            )
                            
                            ForEach(genogramData.genogram) { shape in
                                ZStack {
                                    // Highlight effect when selected
                                    if isConnectingMode && (selectedShapeId == shape.id || startSymbol?.id == shape.id) {
                                        Circle()
                                            .stroke(Color("Dark Green"), lineWidth: 2)
                                            .frame(width: UIHelper.standardIconSize + 20, height: UIHelper.standardIconSize + 20)
                                    }
                                    
                                    Image(shape.imageName)
                                        .resizable()
                                        .frame(width: UIHelper.standardIconSize, height: UIHelper.standardIconSize)
                                }
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
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: UIHelper.standardCornerRadius)
                                                            .stroke(isConnectingMode && selectedIcon == imageName ?
                                                                   Color("Dark Green") : Color.clear,
                                                                   lineWidth: 2)
                                                    )
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
                
                if (genogramData.genogram.isEmpty) {
                    generateTemplate()
                }
                
            }
            .onDisappear {
                // Remove lock when view disappears
                lockOrientation(.all)
            }
        }
        .navigationBarBackButtonHidden(true) // This hides the default back button
    }
    
    struct ConnectionsView: View {
        let genogramData: GenogramData
        let onConnectionTap: (Connection) -> Void
        
        var body: some View {
            ZStack {
                // Handle all connections with a unified approach
                ForEach(genogramData.connections) { connection in
                    ConnectionLineView(
                        connection: connection,
                        genogramData: genogramData
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onConnectionTap(connection)
                    }
                }
            }
        }
        
        // Helper function to get center point of a symbol
        private func getCenter(for symbolId: UUID) -> CGPoint? {
            if let shape = genogramData.genogram.first(where: { $0.id == symbolId }) {
                return shape.position
            }
            return nil
        }
    }

    // Unified view for rendering any type of connection
    struct ConnectionLineView: View {
        let connection: Connection
        let genogramData: GenogramData
        
        var body: some View {
            switch connection.type {
            case .marriage:
                // Marriage-type connections (horizontal line between partners)
                let start = getBottomCenter(for: connection.startSymbolId)
                let end = getBottomCenter(for: connection.endSymbolId)
                
                MarriageConnectionLine(start: start, end: end)
                    .stroke(Color("Candace's Couch"), lineWidth: 2)
                    
            case .child:
                // Child connections (vertical line from parent marriage to child)
                if let parentConnectionId = connection.parentConnectionId,
                   let parentConnection = genogramData.connections.first(where: { $0.id == parentConnectionId }) {
                    
                    let parentStart = getBottomCenter(for: parentConnection.startSymbolId)
                    let parentEnd = getBottomCenter(for: parentConnection.endSymbolId)
                    let childPoint = getTopCenter(for: connection.endSymbolId)
                    
                    // Get all siblings with the same parent connection
                    let siblings = genogramData.connections.filter {
                        $0.type == .child && $0.parentConnectionId == parentConnectionId
                    }.sorted { (conn1, conn2) -> Bool in
                        let pos1 = getSymbolPosition(for: conn1.endSymbolId)
                        let pos2 = getSymbolPosition(for: conn2.endSymbolId)
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
                
            case .abuse:
                // Abuse connections (wavy line)
                let start = getCenter(for: connection.startSymbolId)
                let end = getCenter(for: connection.endSymbolId)
                
                AbuseConnectionLine(start: start, end: end)
                    .stroke(Color.black, lineWidth: 2)
                
            case .harmony:
                let start = getCenter(for: connection.startSymbolId)
                let end = getCenter(for: connection.endSymbolId)
                
                HarmonyConnectionLine(start: start, end: end)
                    .stroke(Color.black, lineWidth: 2)
                
            case .friendship:
                let start = getCenter(for: connection.startSymbolId)
                let end = getCenter(for: connection.endSymbolId)
                
                FriendshipConnectionLine(start: start, end: end)
                    .stroke(Color.black, lineWidth: 2)
                
            case .fusion:
                let start = getCenter(for: connection.startSymbolId)
                let end = getCenter(for: connection.endSymbolId)
                
                FusionConnectionLine(start: start, end: end)
                    .stroke(Color.black, lineWidth: 2)
                
            case .focus:
                let start = getCenter(for: connection.startSymbolId)
                let end = getCenter(for: connection.endSymbolId)
                
                FocusedConnectionLine(start: start, end: end)
                    .stroke(Color.black, lineWidth: 2)
                
            case .dating:
                let start = getBottomCenter(for: connection.startSymbolId)
                let end = getBottomCenter(for: connection.endSymbolId)
                
                MarriageConnectionLine(start: start, end: end)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    .foregroundColor(.black)
                
            case .affair:
                let start = getBottomCenter(for: connection.startSymbolId)
                let end = getBottomCenter(for: connection.endSymbolId)
                AffairConnectionLine(start: start, end: end)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    .foregroundColor(.black)
                            
                            // Draw the filled triangle
                AffairTriangleMarker(start: start, end: end)
                    .fill(.black)
                   
            case .divorce:
                let start = getBottomCenter(for: connection.startSymbolId)
                let end = getBottomCenter(for: connection.endSymbolId)
                DivorceConnectionLine(start: start, end: end)
                    .stroke(Color.black, lineWidth: 2)
                
            default:
                // Default handling for any other connection types
                let start = getCenter(for: connection.startSymbolId)
                let end = getCenter(for: connection.endSymbolId)
                
                Path { path in
                    path.move(to: start)
                    path.addLine(to: end)
                }
                .stroke(Color("Candace's Couch"), lineWidth: 2)
            }
        }
        // Helper methods for getting positions
        private func getCenter(for symbolId: UUID) -> CGPoint {
            if let shape = genogramData.genogram.first(where: { $0.id == symbolId }) {
                return shape.position
            }
            return .zero
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
        
        private func getSymbolPosition(for symbolId: UUID) -> CGPoint {
            if let shape = genogramData.genogram.first(where: { $0.id == symbolId }) {
                return shape.position
            }
            return .zero
        }
        
       
    }
    private func handleSymbolTap(_ shape: GenogramShape) {
        if !isConnectingMode {
            activeShape = shape
            return
        }
        
        if let firstSymbol = startSymbol {
            if firstSymbol.id != shape.id {
                // Create connection between two symbols
                let connection = Connection(
                    id: UUID(),
                    start: getCenter(for: firstSymbol.id),
                    end: getCenter(for: shape.id),
                    startSymbolId: firstSymbol.id,
                    endSymbolId: shape.id,
                    type: selectedConnectionType
                )
                genogramData.connections.append(connection)
            }
            startSymbol = nil
            selectedShapeId = nil
        } else {
            startSymbol = shape
            selectedShapeId = shape.id
        }
    }
    
    private func handleMarriageConnectionTap(_ connection: Connection) {
        if let firstSymbol = startSymbol, connection.type == .marriage {
            let childConnection = Connection(
                id: UUID(),
                start: getTopCenter(for: firstSymbol.id),
                end: connection.parentMiddlePoint ?? .zero,
                startSymbolId: firstSymbol.id,
                endSymbolId: firstSymbol.id,
                type: .child,
                parentConnectionId: connection.id
            )
            genogramData.connections.append(childConnection)
            startSymbol = nil
        }
    }
    
    private func updateConnections(for shape: GenogramShape) {
        genogramData.connections = genogramData.connections.map { connection in
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
    
    private func handleIconTap(imageName: String) {
        // Check if the image is a relationship type
        if relationshipOptions.contains(imageName) || relationshipOptionsLabel.contains(imageName) {
            // Enable connecting mode with the appropriate connection type
            isConnectingMode = true
            selectedConnectionType = getConnectionType(for: imageName)
            selectedIcon = imageName // This will help with visual feedback
        } else {
            // Handle regular icon placement as before
            addIconToGenogram(imageName: imageName)
        }
    }
    
    private func addIconToGenogram(imageName: String) {
        // Calculate the visible center of the screen
        let visibleCenterX = (UIHelper.screenSize.width / 2 - offset.width) / scale
        let visibleCenterY = (UIHelper.screenSize.height / 2 - offset.height) / scale
        
        // Create new shape at the calculated center position
        let newShape = GenogramShape(
            id: UUID(),
            imageName: imageName,
            position: CGPoint(x: visibleCenterX, y: visibleCenterY)
        )
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
        genogramData.connections.append(connection)
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
    
    // Modify the generateTemplate function
    private func generateTemplate() {
        // Check if template has already been generated
        guard !hasGeneratedTemplate else { return }
        
        let baseSpacing: CGFloat = 100 // Base spacing only for first generation
        let startY: CGFloat = 200
        let startX: CGFloat = UIHelper.screenSize.width / 4
        
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
        
        // Calculate midpoints for first generation marriages
        let gen1Pair1Mid = (startX + (startX + baseSpacing)) / 2
        let gen1Pair2Mid = (startX + baseSpacing * 2.5 + (startX + baseSpacing * 3.5)) / 2
        let gen1Pair3Mid = (startX + baseSpacing * 5 + (startX + baseSpacing * 6)) / 2
        let gen1Pair4Mid = (startX + baseSpacing * 7.5 + (startX + baseSpacing * 8.5)) / 2
        
        // Second generation (2 pairs)
        let gen2LeftX = gen1Pair1Mid  // Male under first marriage
        let gen2LeftPartnerX = gen1Pair2Mid  // Female under second marriage
        let gen2RightX = gen1Pair3Mid  // Male under third marriage
        let gen2RightPartnerX = gen1Pair4Mid  // Female under fourth marriage
        
        let gen2Symbols = [
            ("Male", CGPoint(x: gen2LeftX, y: startY + baseSpacing)),
            ("Female", CGPoint(x: gen2LeftPartnerX, y: startY + baseSpacing)),
            ("Male", CGPoint(x: gen2RightX, y: startY + baseSpacing)),
            ("Female", CGPoint(x: gen2RightPartnerX, y: startY + baseSpacing))
        ]
        
        // Calculate midpoints for second generation marriages
        let gen2Pair1Mid = (gen2LeftX + gen2LeftPartnerX) / 2
        let gen2Pair2Mid = (gen2RightX + gen2RightPartnerX) / 2
        
        // Third generation (final pair)
        let gen3Symbols = [
            ("Male", CGPoint(x: gen2Pair1Mid, y: startY + baseSpacing * 2)),
            ("Female", CGPoint(x: gen2Pair2Mid, y: startY + baseSpacing * 2))
        ]
        
        // Create all symbols
        var symbolIds: [[UUID]] = [[],[],[]] // Store IDs by generation
        
        // Add first generation
        for (icon, position) in gen1Symbols {
            let shape = GenogramShape(id: UUID(), imageName: icon, position: position)
            genogramData.genogram.append(shape)
            symbolIds[0].append(shape.id)
        }
        
        // Add second generation
        for (icon, position) in gen2Symbols {
            let shape = GenogramShape(id: UUID(), imageName: icon, position: position)
            genogramData.genogram.append(shape)
            symbolIds[1].append(shape.id)
        }
        
        // Add third generation
        for (icon, position) in gen3Symbols {
            let shape = GenogramShape(id: UUID(), imageName: icon, position: position)
            genogramData.genogram.append(shape)
            symbolIds[2].append(shape.id)
        }
        
        // Create marriage connections
        // First generation marriages (4 pairs)
        var marriageConnections: [Connection] = []
        for i in stride(from: 0, to: symbolIds[0].count, by: 2) {
            let connection = Connection(
                id: UUID(),
                start: getBottomCenter(for: symbolIds[0][i]),
                end: getBottomCenter(for: symbolIds[0][i + 1]),
                startSymbolId: symbolIds[0][i],
                endSymbolId: symbolIds[0][i + 1],
                type: .marriage
            )
            genogramData.connections.append(connection)
            marriageConnections.append(connection)
        }

        // Second generation marriages (2 pairs)
        var gen2MarriageConnections: [Connection] = []
        for i in stride(from: 0, to: symbolIds[1].count, by: 2) {
            let connection = Connection(
                id: UUID(),
                start: getBottomCenter(for: symbolIds[1][i]),
                end: getBottomCenter(for: symbolIds[1][i + 1]),
                startSymbolId: symbolIds[1][i],
                endSymbolId: symbolIds[1][i + 1],
                type: .marriage
            )
            genogramData.connections.append(connection)
            gen2MarriageConnections.append(connection)
        }

        // Third generation marriage (1 pair)
        let finalMarriage = Connection(
            id: UUID(),
            start: getBottomCenter(for: symbolIds[2][0]),
            end: getBottomCenter(for: symbolIds[2][1]),
            startSymbolId: symbolIds[2][0],
            endSymbolId: symbolIds[2][1],
            type: .marriage
        )
        genogramData.connections.append(finalMarriage)

        // Create child connections
        // First generation to second generation connections
        // Left male child to first marriage
        let childConnection1 = Connection(
            id: UUID(),
            start: getTopCenter(for: symbolIds[1][0]),
            end: marriageConnections[0].parentMiddlePoint ?? .zero,
            startSymbolId: symbolIds[1][0],
            endSymbolId: symbolIds[1][0],
            type: .child,
            parentConnectionId: marriageConnections[0].id
        )
        genogramData.connections.append(childConnection1)
        
        // Left female child to second marriage
        let childConnection2 = Connection(
            id: UUID(),
            start: getTopCenter(for: symbolIds[1][1]),
            end: marriageConnections[1].parentMiddlePoint ?? .zero,
            startSymbolId: symbolIds[1][1],
            endSymbolId: symbolIds[1][1],
            type: .child,
            parentConnectionId: marriageConnections[1].id
        )
        genogramData.connections.append(childConnection2)

        // Right male child to third marriage
        let childConnection3 = Connection(
            id: UUID(),
            start: getTopCenter(for: symbolIds[1][2]),
            end: marriageConnections[2].parentMiddlePoint ?? .zero,
            startSymbolId: symbolIds[1][2],
            endSymbolId: symbolIds[1][2],
            type: .child,
            parentConnectionId: marriageConnections[2].id
        )
        genogramData.connections.append(childConnection3)
        
        // Right female child to fourth marriage
        let childConnection4 = Connection(
            id: UUID(),
            start: getTopCenter(for: symbolIds[1][3]),
            end: marriageConnections[3].parentMiddlePoint ?? .zero,
            startSymbolId: symbolIds[1][3],
            endSymbolId: symbolIds[1][3],
            type: .child,
            parentConnectionId: marriageConnections[3].id
        )
        genogramData.connections.append(childConnection4)

        // Second generation to third generation connections
        // Left child to first second-gen marriage
        let childConnection5 = Connection(
            id: UUID(),
            start: getTopCenter(for: symbolIds[2][0]),
            end: gen2MarriageConnections[0].parentMiddlePoint ?? .zero,
            startSymbolId: symbolIds[2][0],
            endSymbolId: symbolIds[2][0],
            type: .child,
            parentConnectionId: gen2MarriageConnections[0].id
        )
        genogramData.connections.append(childConnection5)
        
        // Right child to second second-gen marriage
        let childConnection6 = Connection(
            id: UUID(),
            start: getTopCenter(for: symbolIds[2][1]),
            end: gen2MarriageConnections[1].parentMiddlePoint ?? .zero,
            startSymbolId: symbolIds[2][1],
            endSymbolId: symbolIds[2][1],
            type: .child,
            parentConnectionId: gen2MarriageConnections[1].id
        )
        genogramData.connections.append(childConnection6)
        
        // Mark template as generated at the end of the function
        hasGeneratedTemplate = true
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
    
    // Add helper function to determine connection type
    private func getConnectionType(for relationshipImage: String) -> Connection.ConnectionType {
        switch relationshipImage {
        case "Marriage":
            return .marriage
        case "Normal":
            return .harmony
        case "Cutoff":
            return .friendship
        case "Divorce":
            return .divorce
        case "Separation In Fact":
            return .fusion
        case "Abuse":
            return .abuse
        case "Focused On":
            return .focus
        case "Engaged":
            return .dating
        case "Legal Separation":
            return .affair
        default:
            return .child
        }
    }
    
    // Helper methods for getting positions
    private func getCenter(for symbolId: UUID) -> CGPoint {
        if let shape = genogramData.genogram.first(where: { $0.id == symbolId }) {
            return shape.position
        }
        return .zero
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
    
    private func getSymbolPosition(for symbolId: UUID) -> CGPoint {
        if let shape = genogramData.genogram.first(where: { $0.id == symbolId }) {
            return shape.position
        }
        return .zero
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

// Move Connection struct outside of GenogramBuilder



