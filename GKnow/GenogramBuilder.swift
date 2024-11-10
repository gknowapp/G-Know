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
    
    let isEditable: Bool
    var imageOptions = ["MaleIcon", "FemaleIcon", "AbortionIcon", "MiscarriageIcon", "MaleDeathIcon", "FemaleDeathIcon", "UnknownGenderIcon", "PregnancyIcon"]
    var relationshipOptions = ["CutoffIcon", "MarriageIcon", "DivorceIcon", "EngagedIcon", "CommittedRelationshipIcon", "LegalSeparationIcon", "SeparationInFactIcon", "NormalIcon", "FocusedOnIcon", "FocusedOnNegativelyIcon"]
    var symptomOptions = ["MaleADAbuseIcon", "MaleADRecoveryIcon", "MaleIllnessIcon", "MaleIllnessRecoveryIcon"]
    
    var body: some View {
        ZStack {
            VStack {
                /*Text("Genogram Builder")
                 .font(.largeTitle)
                 .padding()*/
                if isEditable {
                    HStack(alignment: .top){
                        Spacer()
                        Spacer()
                        HStack {
                            DisclosureGroup("People", isExpanded: $showPeopleOptions) {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                                    //                                        HStack {
                                    ForEach(imageOptions, id: \.self) { imageName in
                                        Image(imageName)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                handleIconTap(imageName: imageName)
                                            }
                                    }
                                    //                                        }
                                }
                            }
                            .padding()
                            .foregroundStyle(Color("Candace's Couch"))
                            .frame(width: 320, height: 75)
                            
                            Divider()
                            
                            DisclosureGroup("Relationships", isExpanded: $showRelationshipOptions) {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                                    ForEach(relationshipOptions, id: \.self) { imageName in
                                        Image(imageName)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                handleIconTap(imageName: imageName)
                                            }
                                    }
                                }
                            }
                            .padding()
                            .foregroundStyle(Color("Candace's Couch"))
                            .frame(width: 430, height: 75)
                            
                            Divider()
                            
                            DisclosureGroup("Symptoms", isExpanded: $showSymptomOptions) {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                                    ForEach(symptomOptions, id: \.self) { imageName in
                                        Image(imageName)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                handleIconTap(imageName: imageName)
                                            }
                                    }
                                }
                            }
                            .padding()
                            .foregroundStyle(Color("Candace's Couch"))
                            .frame(width: 270, height: 75)
                        }
                        .background(Color("Light Green"))
                        .frame(height: 75)
                        //.padding(.horizontal)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 40)
                        .shadow(radius: 10)
                        
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Anti-flash White"))
                            .frame(width: 75, height: 200)
                            .padding(.trailing, 50)
                            .padding(.top, 40)
                            .shadow(radius: 5, x:4, y:2)
                    }
                    ZStack {
                        // Display the saved drawing as a background image
                        CanvasView(canvasView: $canvasView, drawing: $savedDrawing, isDrawing: $showDrawingCanvas)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)
                        //.border(Color.gray, width: 2)
                        
                        ForEach(genogramData.genogram) { shape in
                            Image(shape.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
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
                                    activeShape = shape
                                }
                        }
                        
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
                        // Button to toggle the drawing mode
                        if isEditable {
                            Button(action: {
                                if showDrawingCanvas {
                                    savedDrawing = canvasView.drawing // Save the current drawing
                                }
                                showDrawingCanvas.toggle()
                            }) {
                                Text(showDrawingCanvas ? "Exit Drawing" : "Draw")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
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
            .frame(minWidth: 1366, minHeight: 1024)
            .background(Color("White"))
            //.presentationSizing(.fitted)
        }
    }
    
    
    
    private func handleIconTap(imageName: String) {
        iconClickCounter[imageName, default: 0] += 1
        if iconClickCounter[imageName] == 1 {
            selectedIcon = imageName
            isSidePanelVisible = true
        } else if iconClickCounter[imageName] == 2 {
            addIconToGenogram(imageName: imageName)
            iconClickCounter[imageName] = 0
            isSidePanelVisible = false
        }
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
            drawing = uiView.drawing
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

