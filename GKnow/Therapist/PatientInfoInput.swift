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
    
    let backgroundImage = Image("Therapist Background")
        .resizable()

    var body: some View {
        ZStack {
            //Background Image
            HStack {
                backgroundImage
                    .opacity(0.25)
            }
            .overlay(Color ("Overlay"))
            .ignoresSafeArea(.container)
            
            VStack(alignment: .center, spacing: 20) {
                Text(isTherapist ? "Client: \(firstName) \(middleName) \(lastName)" : "My Genogram")
                    .font(.system(size: 72))
                    .foregroundColor(Color("Candace's Couch"))
                    .padding(.top, 40)
                
                if isEditing {
                    VStack(spacing: 10) {
                 /*       inputField(label: "First Name", text: $firstName)
                            .padding(.horizontal, 30)
                            .padding(.top, 10)
                            .font(.title2)
                            .foregroundColor(Color("Candace's Couch"))
                        Divider() */
                        inputField(label: "Middle Name", text: $middleName)
                            .padding(.horizontal, 30)
                            .font(.title2)
                            .foregroundColor(Color("Candace's Couch"))
                        Divider()
                        inputField(label: "Last Name", text: $lastName)
                            .padding(.horizontal, 30)
                            .font(.title2)
                            .foregroundColor(Color("Candace's Couch"))
                        Divider()
                        DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                            .padding(.horizontal, 30)
                            .font(.title2)
                            .foregroundColor(Color("Candace's Couch"))
                        Divider()
                        MultiSelectField(label: "Role", selections: $role, options: ["Hero", "Peacekeeper", "Clown", "Lost Child", "Rebel", "Scapegoat"])
                            .padding(.horizontal, 30)
                            .font(.title2)
                            .foregroundColor(Color("Candace's Couch"))
                        Divider()
                        MultiSelectField(label: "Birth Order", selections: $birthOrder, options: ["Oldest", "Youngest", "Only", "Middle", "Twin"])
                            .padding(.horizontal, 30)
                            .font(.title2)
                            .foregroundColor(Color("Candace's Couch"))
                        /*Divider()*/
                    }
                    //.frame(width: nil, height: nil , alignment: .leading)
                    .background(Color ("Anti-flash White"))
                    .padding(CGFloat(50))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                } else {
                    PatientCardView(firstName: $firstName, middleName: $middleName, lastName: $lastName, dob: $dob, role: $role, birthOrder: $birthOrder, isEditing: $isEditing, showPatientCard: $showPatientCard)
                        .padding()
                        .background(Color ("Dark Green"))
                        .cornerRadius(20)
                        //.shadow(radius: 20)
                    
                }
                
                HStack {
                    Button(action: {
                        isEditing.toggle()
                        showPatientCard.toggle()
                    }) {
                        Text(isEditing ? "Save" : isTherapist ? "Edit Client Information" : "Edit My Information")
                            .padding()
                            .background(Color ("Light Green"))
                            .foregroundColor(Color ("Candace's Couch"))
                            .cornerRadius(10)
                            .font(.title2)
                    }
                    .padding(.bottom, 40)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    if !isEditing {
                        Button(action: {
                            showGenogramBuilder = true
                        }) {
                            Text("Open Genogram Builder")
                                .padding()
                                .background(Color ("Light Green"))
                                .foregroundColor(Color ("Candace's Couch"))
                                .cornerRadius(10)
                                .font(.title2)
                        }
                        
                        .sheet(isPresented: $showGenogramBuilder) {
                            GenogramBuilder(
                                genogramData: $genogramData,
                                selectedIcon: $selectedIcon,
                                isSidePanelVisible: $isSidePanelVisible,
                                isEditable: true
                            )
                        }
                        .padding(.bottom, 40)
                        .shadow(radius: 5)
                    }
                        
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color ("Dark Green"))
            .padding(.horizontal, 150)
            .padding(.vertical, 100)
            .cornerRadius(20)
            .shadow(radius: 20)
        }
        
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
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        VStack(alignment: .leading) {
            Text(label + ":")
                .font(.title2)
            LazyVGrid(columns: columns) {
                
                
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
                    .padding(.horizontal, 10)
                }
            }
        }
        .padding(.bottom, 10)
        
    }

    private func toggleSelection(_ option: String) {
        if selections.contains(option) {
            selections.removeAll { $0 == option }
        } else {
            selections.append(option)
        }
    }
}
