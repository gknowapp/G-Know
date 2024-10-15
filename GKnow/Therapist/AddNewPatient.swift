//  AddNewPatient.swift
//  GKnow
//
//  Created by Catherine Chu on 10/2/24.
//

import SwiftUI

struct AddNewPatient: View {
    @Environment(\.dismiss) var dismiss
    
    // Patient fields
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    @State private var dob: Date = Date() // Date of Birth field
    @State private var selectedRole: Set<String> = [] // Multi-select for roles
    @State private var selectedBirthOrder: Set<String> = [] // Multi-select for birth order

    var onSave: (String) -> Void
    private let airtableService = AirTableService() // Instantiate the Airtable service
    
    // Role and Birth Order options
    let roleOptions = ["Hero", "Peacekeeper", "Clown", "Lost Child", "Rebel", "Scapegoat"]
    let birthOrderOptions = ["Oldest", "Youngest", "Only", "Middle", "Twin"]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add New Patient")
                    .font(.headline)
                
                // First Name Field
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Middle Name Field
                TextField("Middle Name", text: $middleName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Last Name Field
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Date of Birth Picker
                DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                
                // Role Multi-select Picker
                Text("Select Role(s):")
                MultiSelectPicker(options: roleOptions, selections: $selectedRole)
                
                // Birth Order Multi-select Picker
                Text("Select Birth Order:")
                MultiSelectPicker(options: birthOrderOptions, selections: $selectedBirthOrder)
                
                // Save Button
                Button(action: savePatient) {
                    Text("Save")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                
                //Spacer()
            }
            .padding()
            .navigationTitle("Add New Patient Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // Save patient function
    private func savePatient() {
        let newPatient = "\(firstName) \(middleName) \(lastName)"
        let trimmedPatient = newPatient.trimmingCharacters(in: .whitespaces)
        
        let roleArray = Array(selectedRole)
        let birthOrderArray = Array(selectedBirthOrder)
        
        airtableService.addPatient(firstName: firstName, middleName: middleName, lastName: lastName, dob: dob, role: roleArray, birthOrder: birthOrderArray) { success in
            if success {
                DispatchQueue.main.async {
                    onSave(trimmedPatient) // Call the onSave closure
                    print("Patient saved successfully: \(trimmedPatient)") // Debugging print
                    dismiss() // Dismiss the view
                }
            } else {
                DispatchQueue.main.async {
                    print("Error saving patient.") // Debugging print
                }
            }
        }
    }
}

// Multi-select picker component
struct MultiSelectPicker: View {
    let options: [String]
    @Binding var selections: Set<String>

    var body: some View {
        List(options, id: \.self) { option in
            MultipleSelectionRow(title: option, isSelected: selections.contains(option)) {
                if selections.contains(option) {
                    selections.remove(option)
                } else {
                    selections.insert(option)
                }
            }
        }
    }
}

// Row for each option in multi-select picker
struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
