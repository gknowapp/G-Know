import SwiftUI

struct GenogramBuilder: View {
    @Binding var genogramData: GenogramData
    @Binding var selectedIcon: String?
    @Binding var isSidePanelVisible: Bool
    @State private var activeShape: GenogramShape? = nil
    @State private var showNotesPopup: Bool = false
    @State private var iconClickCounter: [String: Int] = [:] // Tracks how many times each icon has been clicked
    @State private var showPeopleOptions = false
    @State private var showRelationshipOptions = false
    @State private var showSymptomOptions = false

    let isEditable: Bool
    var imageOptions = ["MaleIcon", "FemaleIcon", "AbortionIcon", "MiscarriageIcon", "MaleDeathIcon", "FemaleDeathIcon", "UnknownGenderIcon", "PregnancyIcon"]
    var relationshipOptions = ["CutoffIcon", "MarriageIcon", "DivorceIcon", "EngagedIcon", "CommittedRelationshipIcon", "LegalSeparationIcon", "SeparationInFactIcon", "NormalIcon", "FocusedOnIcon", "FocusedOnNegativelyIcon"]
    var symptomOptions = ["MaleADAbuseIcon", "MaleADRecoveryIcon", "MaleIllnessIcon", "MaleIllnessRecoveryIcon"]

    static func initialGenogramData() -> [GenogramShape] {
            return [
                // Grandparents
                GenogramShape(id: UUID(), imageName: "MaleIcon", position: CGPoint(x: 100, y: 100)),
                GenogramShape(id: UUID(), imageName: "FemaleIcon", position: CGPoint(x: 200, y: 100)),

                // Parents (first pair)
                GenogramShape(id: UUID(), imageName: "MaleIcon", position: CGPoint(x: 100, y: 200)),
                GenogramShape(id: UUID(), imageName: "FemaleIcon", position: CGPoint(x: 200, y: 200)),

                // Parents (second pair)
                GenogramShape(id: UUID(), imageName: "MaleIcon", position: CGPoint(x: 300, y: 200)),
                GenogramShape(id: UUID(), imageName: "FemaleIcon", position: CGPoint(x: 400, y: 200)),

                // Patient
                GenogramShape(id: UUID(), imageName: "FemaleIcon", position: CGPoint(x: 250, y: 300))
            ]
        }

    let gridItemLayout = [GridItem(.adaptive(minimum: 50))]
    
    var body: some View {
        VStack {
            Text("Genogram Builder")
                .font(.largeTitle)
                .padding()

            if isEditable {
                            VStack {
                                DisclosureGroup("People", isExpanded: $showPeopleOptions) {
                                    LazyVGrid(columns: gridItemLayout) {
//                                        HStack {
                                            ForEach(imageOptions, id: \.self) { imageName in
                                                Image(imageName)
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                    .padding()
                                                    .background(Color.gray.opacity(0.2))
                                                    .cornerRadius(10)
                                                    .onTapGesture {
                                                        handleIconTap(imageName: imageName)
                                                    }
                                            }
                                        //                                        }
                                    }
                                }
                                .padding()

                    Divider()

                                DisclosureGroup("Relationships", isExpanded: $showRelationshipOptions) {
                                    LazyVGrid(columns: gridItemLayout) {
//                                                            HStack {
                                                                ForEach(relationshipOptions, id: \.self) { imageName in
                                                                    Image(imageName)
                                                                        .resizable()
                                                                        .frame(width: 50, height: 50)
                                                                        .padding()
                                                                        .background(Color.gray.opacity(0.2))
                                                                        .cornerRadius(10)
                                                                        .onTapGesture {
                                                                            handleIconTap(imageName: imageName)
                                                                        }
                                                                }
                                        //                                                            }
                                                        }
                                                    }
                                                    .padding()

                    Divider()

                                DisclosureGroup("Symptoms", isExpanded: $showSymptomOptions) {
                                    LazyVGrid(columns: gridItemLayout) {
//                                                           HStack {
                                                               ForEach(symptomOptions, id: \.self) { imageName in
                                                                   Image(imageName)
                                                                       .resizable()
                                                                       .frame(width: 50, height: 50)
                                                                       .padding()
                                                                       .background(Color.gray.opacity(0.2))
                                                                       .cornerRadius(10)
                                                                       .onTapGesture {
                                                                           handleIconTap(imageName: imageName)
                                                                       }
                                                                   //                                                               }
                                                           }
                                                       }
                                                   }
                                                   .padding()
                                               }
                                               .background(Color.gray.opacity(0.3))
                                               .padding(.horizontal)
                                           }

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
    }

    private func handleIconTap(imageName: String) {
        // Increment the counter for the selected icon
        iconClickCounter[imageName, default: 0] += 1

        // Check if the icon has been clicked once or twice
        if iconClickCounter[imageName] == 1 {
            // Show the side panel
            selectedIcon = imageName
            isSidePanelVisible = true
        } else if iconClickCounter[imageName] == 2 {
            // Insert the icon into the genogram and reset the counter for this icon
            addIconToGenogram(imageName: imageName)
            iconClickCounter[imageName] = 0
            isSidePanelVisible = false
        }
    }

    private func addIconToGenogram(imageName: String) {
        // Add the selected icon to the genogram with a default position
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

// Model to represent each shape with an image and notes
struct GenogramShape: Identifiable {
    var id: UUID
    var imageName: String
    var position: CGPoint
    var notes: String = "" // Optional notes for each shape
}

struct GenogramData {
    var genogram: [GenogramShape] // The collection of shapes in the genogram
}

// View for editing notes for a selected shape in the genogram
struct NotesPopupView: View {
    @Binding var shape: GenogramShape // Binding to the selected shape
    var isEditable: Bool // Whether the notes can be edited

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notes")) {
                    if isEditable {
                        TextEditor(text: $shape.notes) // TextEditor for editable notes
                            .frame(height: 200)
                    } else {
                        Text(shape.notes) // Display notes if not editable
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
