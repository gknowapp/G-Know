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
                if isEditable {
                    HStack(alignment: .top){
                        Spacer()
                        Spacer()
                        HStack {
                            
                            DisclosureGroup(
                                content: {
                                    HStack {
                                        //                                        HStack {
                                        ForEach(imageOptions, id: \.self) { imageName in
                                            Image(imageName)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .padding(.horizontal, 5)
                                                .padding(.vertical, 10)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    handleIconTap(imageName: imageName)
                                                }
                                        }
                                        //                                        }
                                    }
                                    .padding(.trailing, 35)
                                },
                                label: {
                                    HStack {
                                        ForEach(imageOptionsLabel, id: \.self) { imageName in
                                            
                                            Image(imageName)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .padding(.horizontal, 5)
                                            //.padding(.leading, 50)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    handleIconTap(imageName: imageName)
                                                }
                                        }
                                    }
                                }
                            )
                            /*DisclosureGroup("People", isExpanded: $showPeopleOptions) {
                             LazyVGrid(columns: column3) {
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
                             }*/
                            .padding(.leading, 15)
                            .padding(.trailing, 5)
                            .accentColor(Color("Candace's Couch"))
                            .foregroundStyle(Color("Candace's Couch"))
                            .frame(width: 320)
                            
                            Divider()
                            DisclosureGroup(
                                content: {
                                    HStack {
                                        ForEach(relationshipOptions, id: \.self) { imageName in
                                            Image(imageName)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 10)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    handleIconTap(imageName: imageName)
                                                }
                                        }
                                    }
                                    .padding(.trailing, 27)
                                },
                                label: {
                                    HStack {
                                        ForEach(relationshipOptionsLabel, id: \.self) { imageName in
                                            Image(imageName)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .padding(.horizontal, 10)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    
                                                    handleIconTap(imageName: imageName)
                                                }
                                            
                                        }
                                    }
                                }
                            )
                            
                            /*DisclosureGroup("Relationships", isExpanded: $showRelationshipOptions) {
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
                             }*/
                            .padding(.leading, 15)
                            .padding(.trailing, 5)
                            .accentColor(Color("Candace's Couch"))
                            .foregroundStyle(Color("Candace's Couch"))
                            .frame(width: 430)
                            
                            Divider()
                            DisclosureGroup(
                                content: {
                                    HStack {
                                        ForEach(symptomOptions, id: \.self) { imageName in
                                            Image(imageName)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 10)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    handleIconTap(imageName: imageName)
                                                }
                                        }
                                    }
                                    .padding(.trailing, 20)
                                },
                                label: {
                                    HStack {
                                        ForEach(symptomOptionsLabel, id: \.self) { imageName in
                                            Image(imageName)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .padding(.horizontal, 10)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    handleIconTap(imageName: imageName)
                                                }
                                            
                                        }
                                    }
                                }
                            )
                            /*DisclosureGroup("Symptoms", isExpanded: $showSymptomOptions) {
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
                             }*/
                            .padding(.leading, 10)
                            .padding(.trailing, 15)
                            .accentColor(Color("Candace's Couch"))
                            .foregroundStyle(Color("Candace's Couch"))
                            .frame(width: 270)
                            
                            
                        }
                        .background(Color("Light Green"))
                        .frame(minHeight: 75, maxHeight: 150)
                        //.padding(.horizontal)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 40)
                        .shadow(radius: 10, x:2, y:4)
                        
                        
                        
                        
                        Spacer()
                            ZStack {
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
                            }
                    }
                    ZStack {
                        // Display the saved drawing as a background image
                        CanvasView(canvasView: $canvasView, drawing: $savedDrawing, isDrawing: $showDrawingCanvas)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)
                        
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
            .frame(minWidth: 1366, minHeight: 1024)
            .background(Color("White"))
            //.presentationSizing(.fitted)
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
