import SwiftUI

struct GenogramBuilder: View {
    struct Client {
        var name: String
        var genogram: [GenogramShape]
    }

    @State var client: Client
    @State private var activeShape: GenogramShape? = nil
    @State private var selectedImage: String? = nil // Holds the selected image
    @State private var showNotesPopup: Bool = false // Controls the popup visibility
    @State private var dragOffset: CGSize = .zero
    
    let isEditable: Bool
    var imageOptions = ["MaleIcon", "FemaleIcon"]
    
    var body: some View {
        VStack {
            Text("\(client.name)'s Genogram")
                .font(.largeTitle)
                .padding()

            // Toolbar for selecting images (only if editable)
            if isEditable {
                HStack {
                    Text("Pick an Icon")
                        .font(.headline)
                    
                    ForEach(imageOptions, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .onTapGesture {
                                // Store the selected image to "pick it up"
                                selectedImage = imageName
                            }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.3))
            }
            
            // Genogram canvas (click to place the image)
            ZStack {
                ForEach(client.genogram) { shape in
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
            .background(Color.gray.opacity(0.1))
            .border(Color.gray, width: 2)
            .onTapGesture { location in
                // Place the selected image at the clicked location
                if let imageName = selectedImage, isEditable {
                    addNewShape(withImage: imageName, at: location)
                    selectedImage = nil // Clear the selected image after placing
                }
            }
            
            Spacer()
            
            // Show "Notes" and "Delete" buttons if a shape is selected
            if let selectedShape = activeShape {
                HStack {
                    Button(action: {
                        showNotesPopup = true // Show the popup when "Notes" is clicked
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
        }
        .padding()
        .sheet(isPresented: $showNotesPopup) {
            if let shape = activeShape {
                // Pass the active shape to the NotesPopupView
                NotesPopupView(shape: Binding(
                    get: {
                        if let index = client.genogram.firstIndex(where: { $0.id == shape.id }) {
                            return client.genogram[index]
                        }
                        return shape
                    },
                    set: { updatedShape in
                        if let index = client.genogram.firstIndex(where: { $0.id == updatedShape.id }) {
                            client.genogram[index] = updatedShape
                        }
                    }
                ), isEditable: isEditable)
            }
        }
    }
    
    // Add a new shape at the clicked location
    private func addNewShape(withImage imageName: String, at location: CGPoint) {
        let newShape = GenogramShape(id: UUID(), imageName: imageName, position: location)
        client.genogram.append(newShape)
    }
    
    // Move an existing shape to a new location
    private func moveShape(shape: GenogramShape, newLocation: CGPoint) {
        if let index = client.genogram.firstIndex(where: { $0.id == shape.id }) {
            client.genogram[index].position = newLocation
        }
    }
    
    // Delete the active shape from the canvas
    private func deleteActiveShape() {
        if let activeShape = activeShape, let index = client.genogram.firstIndex(where: { $0.id == activeShape.id }) {
            client.genogram.remove(at: index)
            self.activeShape = nil
        }
    }
}

// Model to represent the shape with an image and notes
struct GenogramShape: Identifiable {
    var id: UUID
    var imageName: String
    var position: CGPoint
    var notes: String = "" // Store notes for the shape
}

// Popup View for viewing and editing notes
struct NotesPopupView: View {
    @Binding var shape: GenogramShape // Pass the shape to edit/view
    let isEditable: Bool
    @State private var tempNotes: String = "" // Temporary storage for editing notes
    
    var body: some View {
        VStack {
            Text("Notes for \(shape.imageName)")
                .font(.headline)
                .padding()
            
            TextEditor(text: $tempNotes)
                .frame(height: 150)
                .border(Color.gray)
                .padding()
                .disabled(!isEditable) // Disable editing if not in editable mode
            
            if isEditable {
                Button(action: {
                    // Save the edited notes back to the shape
                    shape.notes = tempNotes
                }) {
                    Text("Save")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            Button(action: {
                // Close the popup
                shape = shape // Trigger state change
            }) {
                Text("Close")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            // Load the existing notes into the text editor
            tempNotes = shape.notes
        }
    }
}
