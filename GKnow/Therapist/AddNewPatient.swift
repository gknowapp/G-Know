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
    @State private var dob: Date = Date()
    @State private var selectedRole: Set<String> = []
    @State private var selectedBirthOrder: Set<String> = []
    @State private var showRoleOptions: Bool = false
    @State private var showBirthOrderOptions: Bool = false
    
    var onSave: (String) -> Void
    private let airtableService = AirTableService()
    
    // Role and Birth Order options
    let roleOptions = ["Hero", "Peacekeeper", "Clown", "Lost Child", "Rebel", "Scapegoat"]
    let birthOrderOptions = ["Oldest", "Youngest", "Only", "Middle", "Twin"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color("Anti-flash White").ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    Text("Add Patient")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Dark Green"))
                        .padding(.horizontal, 30)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            // First Name
                            VStack(alignment: .leading, spacing: 10) {
                                Text("First Name")
                                    .font(.headline)
                                    .foregroundColor(Color("Dark Green"))
                                
                                TextField("", text: $firstName)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            
                            // Middle Name
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Middle Name")
                                    .font(.headline)
                                    .foregroundColor(Color("Dark Green"))
                                
                                TextField("", text: $middleName)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            
                            // Last Name
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Last Name")
                                    .font(.headline)
                                    .foregroundColor(Color("Dark Green"))
                                
                                TextField("", text: $lastName)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            
                            // Date of Birth - Fixed styling
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Date of Birth")
                                    .font(.headline)
                                    .foregroundColor(Color("Dark Green"))
                                
                                DatePicker("", selection: $dob, displayedComponents: .date)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            
                            // Add Info Button (Role and Birth Order)
                            VStack(alignment: .leading, spacing: 15) {
                                Button(action: {
                                    showRoleOptions.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(Color("Dark Green"))
                                        Text("Add Role")
                                            .foregroundColor(Color("Dark Green"))
                                            .font(.headline)
                                    }
                                    .padding(.vertical, 5)
                                }
                                
                                if showRoleOptions {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Select Role(s)")
                                            .font(.headline)
                                            .foregroundColor(Color("Dark Green"))
                                        
                                        AddPatientMultiSelectField(options: roleOptions, selections: $selectedRole)
                                            .padding(.vertical, 5)
                                    }
                                }
                                
                                Button(action: {
                                    showBirthOrderOptions.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(Color("Dark Green"))
                                        Text("Add Birth Order")
                                            .foregroundColor(Color("Dark Green"))
                                            .font(.headline)
                                    }
                                    .padding(.vertical, 5)
                                }
                                
                                if showBirthOrderOptions {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Select Birth Order")
                                            .font(.headline)
                                            .foregroundColor(Color("Dark Green"))
                                        
                                        AddPatientMultiSelectField(options: birthOrderOptions, selections: $selectedBirthOrder)
                                            .padding(.vertical, 5)
                                    }
                                }
                            }
                            
                            // Action Buttons
                            HStack(spacing: 15) {
                                Spacer()
                                
                                // Save Patient Button
                                Button(action: {
                                    savePatient()
                                }) {
                                    Text("Save Patient")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 25)
                                        .background(Color("Light Green"))
                                        .cornerRadius(10)
                                }
                                
                                // Create Diagram Button
                                Button(action: {
                                    // Action for creating diagram
                                }) {
                                    Text("Create Diagram")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 25)
                                        .background(Color("Dark Green"))
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Cancel")
                        }
                        .foregroundColor(Color("Dark Green"))
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
                    onSave(trimmedPatient)
                    print("Patient saved successfully: \(trimmedPatient)")
                    dismiss()
                }
            } else {
                DispatchQueue.main.async {
                    print("Error saving patient.")
                }
            }
        }
    }
}

// Enhanced multi-select field
struct AddPatientMultiSelectField: View {
    let options: [String]
    @Binding var selections: Set<String>
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 12) {
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
    
    private func toggleSelection(_ option: String) {
        if selections.contains(option) {
            selections.remove(option)
        } else {
            selections.insert(option)
        }
    }
}
