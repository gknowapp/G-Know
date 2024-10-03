import SwiftUI

// Model to represent the shape with an image and notes
struct GenogramShape: Identifiable {
    var id: UUID
    var imageName: String
    var position: CGPoint
    var notes: String = "" // Store notes for the shape
}

struct GenogramData {
    var genogram: [GenogramShape] // The array of shapes in the genogram
}

struct GenogramBuilder: View {
    @State var genogramData: GenogramData // Use the new model
    @State private var activeShape: GenogramShape? = nil
    @State private var selectedImage: String? = nil
    @State private var showNotesPopup: Bool = false

    let isEditable: Bool
    var imageOptions = ["MaleIcon", "FemaleIcon"]

    var body: some View {
        VStack {
            Text("Genogram Builder") // No client name here
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
                                selectedImage = imageName
                            }
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.3))
            }

            // Genogram canvas
            ZStack {
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
            .background(Color.gray.opacity(0.1))
            .border(Color.gray, width: 2)
            .onTapGesture { location in
                if let imageName = selectedImage, isEditable {
                    addNewShape(withImage: imageName, at: location)
                    selectedImage = nil
                }
            }

            Spacer()

            // Show "Notes" and "Delete" buttons if a shape is selected
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
        }
        .padding()
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
    }

    private func addNewShape(withImage imageName: String, at location: CGPoint) {
        let newShape = GenogramShape(id: UUID(), imageName: imageName, position: location)
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


struct NotesPopupView: View {
    @Binding var shape: GenogramShape // Use Binding to get the current shape
    var isEditable: Bool // A flag to determine if editing is allowed

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notes")) {
                    TextEditor(text: $shape.notes) // TextEditor for editing notes
                        .frame(height: 200)
                }
            }
            .navigationTitle("Edit Notes")
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the popup when done
            })
        }
    }
}
