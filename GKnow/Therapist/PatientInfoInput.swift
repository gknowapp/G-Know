import SwiftUI

struct PatientInfoInput: View {
    @Environment(\.dismiss) private var dismiss
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
    @State private var genogramData = GenogramData(genogram: [], connections: [])
    
    @State private var selectedIcon: String? = nil
    @State private var isSidePanelVisible: Bool = false
    @State private var navigateToGenogramBuilder = false
    
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
        NavigationStack {
            ZStack {
                // Clean white background
                Color("Anti-flash White").ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(isTherapist ? "Client Information" : "My Information")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color("Dark Green"))
                            
                            Text(isEditing ? "Edit details below" : "\(firstName) \(lastName)")
                                .font(.title2)
                                .foregroundColor(Color("Dark Green").opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // Edit/Save button
                        Button(action: {
                            isEditing.toggle()
                            if isEditing == false {
                                // Save logic would go here
                                showPatientCard = true
                            }
                        }) {
                            HStack {
                                Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                                Text(isEditing ? "Save" : "Edit")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color("Light Green"))
                            .foregroundColor(Color("Dark Green"))
                            .cornerRadius(8)
                        }
                        
                        // View Genogram button
                        Button(action: {
                            navigateToGenogramBuilder = true
                        }) {
                            HStack {
                                Image(systemName: "chart.bar.doc.horizontal")
                                Text("View Genogram")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color("Dark Green"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                    
                    // Main content
                    if isEditing {
                        // Edit form
                        ScrollView {
                            VStack(alignment: .leading, spacing: 25) {
                                // Personal Information Section
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Personal Information")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("Dark Green"))
                                    
                                    // Name fields
                                    HStack(spacing: 15) {
                                        // First Name
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("First Name")
                                                .font(.headline)
                                                .foregroundColor(Color("Dark Green"))
                                            
                                            TextField("First Name", text: $firstName)
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(8)
                                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                        }
                                        .frame(maxWidth: .infinity)
                                        
                                        // Middle Name
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Middle Name")
                                                .font(.headline)
                                                .foregroundColor(Color("Dark Green"))
                                            
                                            TextField("Middle Name (Optional)", text: $middleName)
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(8)
                                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                        }
                                        .frame(maxWidth: .infinity)
                                        
                                        // Last Name
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Last Name")
                                                .font(.headline)
                                                .foregroundColor(Color("Dark Green"))
                                            
                                            TextField("Last Name", text: $lastName)
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(8)
                                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    
                                    // Date of Birth
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Date of Birth")
                                            .font(.headline)
                                            .foregroundColor(Color("Dark Green"))
                                        
                                        DatePicker("", selection: $dob, displayedComponents: .date)
                                            .datePickerStyle(CompactDatePickerStyle())
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    }
                                }
                                .padding(25)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .padding(.horizontal, 30)
                                
                                // Additional Information Section
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Additional Information")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("Dark Green"))
                                    
                                    // Role selection
                                    EnhancedMultiSelectField(
                                        label: "Role in Family",
                                        selections: $role,
                                        options: ["Parent", "Child", "Sibling", "Spouse", "Extended Family"]
                                    )
                                    
                                    // Birth Order selection
                                    EnhancedMultiSelectField(
                                        label: "Birth Order",
                                        selections: $birthOrder,
                                        options: ["First Born", "Middle Child", "Last Born", "Only Child"]
                                    )
                                }
                                .padding(25)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .padding(.horizontal, 30)
                            }
                            .padding(.bottom, 30)
                        }
                    } else {
                        // View mode - display patient information
                        ScrollView {
                            VStack(alignment: .leading, spacing: 25) {
                                // Personal Information Card
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Personal Information")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("Dark Green"))
                                    
                                    HStack(spacing: 30) {
                                        infoRow(label: "Full Name", value: "\(firstName) \(middleName.isEmpty ? "" : "\(middleName) ")\(lastName)")
                                        infoRow(label: "Date of Birth", value: formatDate(dob))
                                    }
                                }
                                .padding(25)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .padding(.horizontal, 30)
                                
                                // Additional Information Card
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Additional Information")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("Dark Green"))
                                    
                                    HStack(spacing: 30) {
                                        infoRow(label: "Role in Family", value: role.joined(separator: ", "))
                                        infoRow(label: "Birth Order", value: birthOrder.joined(separator: ", "))
                                    }
                                }
                                .padding(25)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .padding(.horizontal, 30)
                            }
                            .padding(.bottom, 30)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(Color("Dark Green"))
                }
            )
            .navigationDestination(isPresented: $navigateToGenogramBuilder) {
                GenogramBuilder(
                                                genogramData: $genogramData,
                                                selectedIcon: $selectedIcon,
                                                isSidePanelVisible: $isSidePanelVisible,
                                                isEditable: true
                    )
            }
        }
    }
    
    // Helper function to format date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Helper function to create info rows
    private func infoRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color.gray)
            
            Text(value.isEmpty ? "Not specified" : value)
                .font(.body)
                .foregroundColor(Color("Dark Green"))
        }
    }
}

// Enhanced multi-select field with better styling
struct EnhancedMultiSelectField: View {
    let label: String
    @Binding var selections: [String]
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(label)
                .font(.headline)
                .foregroundColor(Color("Dark Green"))
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        toggleSelection(option)
                    }) {
                        HStack {
                            Image(systemName: selections.contains(option) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selections.contains(option) ? Color("Dark Green") : Color.gray.opacity(0.5))
                            
                            Text(option)
                                .foregroundColor(Color("Dark Green"))
                            
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selections.contains(option) ? Color("Dark Green") : Color.gray.opacity(0.3), lineWidth: 1)
                                .background(
                                    selections.contains(option) ?
                                        Color("Light Green").opacity(0.2) :
                                        Color.white
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
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
