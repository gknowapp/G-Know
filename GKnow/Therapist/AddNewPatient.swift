//  AddNewPatient.swift
//  GKnow
//
//  Created by Catherine Chu on 10/2/24.
//

import SwiftUI

struct AddNewPatient: View {
    @Environment(\.dismiss) var dismiss
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    
    var onSave: (String) -> Void
    private let airtableService = AirTableService() // Instantiate the Airtable service

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add New Patient")
                    .font(.headline)
                
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Middle Name", text: $middleName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: savePatient) {
                    Text("Save")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                
                Spacer()
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
    
    private func savePatient() {
        let newPatient = "\(firstName) \(middleName) \(lastName)"
        let trimmedPatient = newPatient.trimmingCharacters(in: .whitespaces)

        airtableService.addPatient(firstName: firstName, middleName: middleName, lastName: lastName) { success in
            if success {
                DispatchQueue.main.async {
                    onSave(trimmedPatient) // Call the onSave closure
                    print("Patient saved successfully: \(trimmedPatient)") // Debugging print
                    dismiss() // Attempt to dismiss the view
                }
            } else {
                DispatchQueue.main.async {
                    // Handle error (e.g., show an alert)
                    print("Error saving patient.") // Debugging print
                }
            }
        }
    }
}
