import SwiftUI

struct PatientInfoInput: View {
    let isTherapist: Bool
    let patient: PatientInformation

    @State private var firstName: String
    @State private var middleName: String
    @State private var lastName: String
    
    @State private var dob: Date
    @State private var role: [String]
    @State private var birthOrder: [String]
    
    @State private var showPatientCard: Bool = false
    @State private var isEditing: Bool = false
    @State private var showGenogramBuilder: Bool = false
    @State private var genogramData = GenogramData(genogram: [])

    @State private var selectedIcon: String? = nil
    @State private var isSidePanelVisible: Bool = false

    init(isTherapist: Bool, patient: PatientInformation) {
        self.isTherapist = isTherapist
        self.patient = patient

        _firstName = State(initialValue: patient.fields.firstName ?? "")
        _middleName = State(initialValue: patient.fields.middleName ?? "")
        _lastName = State(initialValue: patient.fields.lastName ?? "")
        _dob = State(initialValue: patient.fields.dob ?? Date())
        _role = State(initialValue: patient.fields.role ?? [])
        _birthOrder = State(initialValue: patient.fields.birthOrder ?? [])
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(isTherapist ? "Client: \(firstName) \(middleName) \(lastName)" : "My Genogram")
                .font(.headline)

            if isEditing {
                VStack(spacing: 10) {
                    inputField(label: "First Name", text: $firstName)
                    inputField(label: "Middle Name", text: $middleName)
                    inputField(label: "Last Name", text: $lastName)
                    DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                    MultiSelectField(label: "Role", selections: $role, options: ["hero", "peacekeeper", "clown", "lost child", "rebel", "scapegoat"])
                    MultiSelectField(label: "Birth Order", selections: $birthOrder, options: ["oldest", "youngest", "only", "middle", "twin"])
                }
            } else {
                PatientCardView(firstName: $firstName, middleName: $middleName, lastName: $lastName, dob: $dob, role: $role, birthOrder: $birthOrder, isEditing: $isEditing, showPatientCard: $showPatientCard)
                    .padding(.top)
            }

            Button(action: {
                isEditing.toggle()
                showPatientCard.toggle()
            }) {
                Text(isEditing ? "Save" : isTherapist ? "Edit Client Information" : "Edit My Information")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)

            if !isEditing {
                Button(action: {
                    showGenogramBuilder = true
                }) {
                    Text("Open Genogram Builder")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                .sheet(isPresented: $showGenogramBuilder) {
                    GenogramBuilder(
                        genogramData: $genogramData,
                        selectedIcon: $selectedIcon,
                        isSidePanelVisible: $isSidePanelVisible,
                        isEditable: true
                    )
                }
            }
        }
        .padding()
    }

    private func inputField(label: String, text: Binding<String>) -> some View {
        HStack {
            Text(label + ":")
            TextField("Enter \(label.lowercased())", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

// MultiSelectField component for selecting multiple items
struct MultiSelectField: View {
    let label: String
    @Binding var selections: [String]
    let options: [String] // The available options for selection

    var body: some View {
        VStack(alignment: .leading) {
            Text(label + ":")
            ForEach(options, id: \.self) { option in
                HStack {
                    Text(option)
                    Spacer()
                    Button(action: {
                        toggleSelection(option)
                    }) {
                        Image(systemName: selections.contains(option) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selections.contains(option) ? .green : .gray)
                    }
                }
            }
        }
    }

    private func toggleSelection(_ option: String) {
        if selections.contains(option) {
            selections.removeAll { $0 == option }
        } else {
            selections.append(option)
        }
    }
}
