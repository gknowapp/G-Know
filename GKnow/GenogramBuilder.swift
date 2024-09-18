import SwiftUI

struct GenogramBuilder: View {
    @State private var selectedShape: String = "Circle"
    @State private var shapes: [GenogramShape] = []
    @State private var showPopup: Bool = false
    @State private var activeShape: GenogramShape? = nil

    var shapeOptions = ["Circle", "Square", "Triangle"]

    var body: some View {
        VStack {
            // Header bar with shape selection dropdown
            HStack {
                Text("Genogram Builder")
                    .font(.largeTitle)
                    .padding(.leading)

                Spacer()

                // Dropdown for shape selection
                Picker("Select Shape", selection: $selectedShape) {
                    ForEach(shapeOptions, id: \.self) { shape in
                        Text(shape)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                Button(action: {
                    addNewShape()
                }) {
                    Text("Add Shape")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.trailing)
            }
            .padding(.top)

            // Genogram canvas (for drag and drop shapes)
            ZStack {
                ForEach(shapes) { shape in
                    ShapeView(shape: shape, onShapeClick: { clickedShape in
                        activeShape = clickedShape
                        showPopup = true
                    })
                    .position(x: shape.position.x, y: shape.position.y) // Position based on drag
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                moveShape(shape: shape, newLocation: value.location)
                            }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            .border(Color.gray, width: 2)

            Spacer()
        }
        .padding()

        // Popup to display or edit information
        .sheet(isPresented: $showPopup, content: {
            if let shape = activeShape {
                ShapeInfoPopup(shape: $activeShape)
            }
        })
    }

    // Add new shape to the genogram
    func addNewShape() {
        let newShape = GenogramShape(id: UUID(), type: selectedShape, position: CGPoint(x: 100, y: 100))
        shapes.append(newShape)
    }

    // Update shape's position while dragging
    func moveShape(shape: GenogramShape, newLocation: CGPoint) {
        if let index = shapes.firstIndex(where: { $0.id == shape.id }) {
            shapes[index].position = newLocation
        }
    }
}

// Model to represent the shape
struct GenogramShape: Identifiable {
    var id: UUID
    var type: String
    var position: CGPoint
    var info: String = "" // Additional info to store for each shape
}

// View for individual shape (circle, square, triangle)
struct ShapeView: View {
    var shape: GenogramShape
    var onShapeClick: (GenogramShape) -> Void

    var body: some View {
        Group {
            if shape.type == "Circle" {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        onShapeClick(shape)
                    }
            } else if shape.type == "Square" {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        onShapeClick(shape)
                    }
            } else if shape.type == "Triangle" {
                Triangle()
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        onShapeClick(shape)
                    }
            }
        }
    }
}

// ShapeInfoPopup to display a sheet with shape info
struct ShapeInfoPopup: View {
    @Binding var shape: GenogramShape?

    var body: some View {
        VStack {
            if let shape = shape {
                Text("Edit Shape Info")
                    .font(.headline)
                    .padding()

                TextField("Enter information", text: Binding(get: {
                    shape.info
                }, set: { newValue in
                    self.shape?.info = newValue
                }))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                Button(action: {
                    self.shape = nil // Close the popup
                }) {
                    Text("Close")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                Text("No shape selected")
                    .padding()
            }
        }
        .padding()
    }
}

// Custom triangle shape for SwiftUI
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct GenogramBuilder_Previews: PreviewProvider {
    static var previews: some View {
        GenogramBuilder()
    }
}

