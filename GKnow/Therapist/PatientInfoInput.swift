//  PatientInfoInput.swift
//  GKnow
//
//  Created by Catherine Chu on 10/2/24.
//
import SwiftUI

struct PatientInfoInput: View {
    let isTherapist: Bool
    let patient: PatientInformation

    @State private var firstName: String
    @State private var middleName: String
    @State private var lastName: String
    
    @State private var showPatientCard: Bool = false
    @State private var isEditing: Bool = false
    @State private var showGenogramBuilder: Bool = false // State variable to control GenogramBuilder display
    @State private var genogramData = GenogramData(genogram: [])

    // Initializer to set initial values
    init(isTherapist: Bool, patient: PatientInformation) {
        self.isTherapist = isTherapist
        self.patient = patient

        // Initialize state variables with patient data
        _firstName = State(initialValue: patient.fields.firstName ?? "")
        _middleName = State(initialValue: patient.fields.middleName ?? "")
        _lastName = State(initialValue: patient.fields.lastName ?? "")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            Text(isTherapist ? "Client: \(firstName) \(lastName)" : "My Genogram")
                .font(.headline)

            // Conditional display of text fields or patient card
            if isEditing {
                // Editing mode
                VStack(spacing: 10) {
                    inputField(label: "First Name", text: $firstName)
                    inputField(label: "Middle Name", text: $middleName)
                    inputField(label: "Last Name", text: $lastName)
                }
            } else {
                // Display patient information
                PatientCardView(firstName: $firstName, middleName: $middleName, lastName: $lastName, isEditing: $isEditing, showPatientCard: $showPatientCard)
                    .padding(.top)
            }

            // Edit/Save button
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

            // Show GenogramBuilder button if not in editing mode
            if !isEditing {
                Button(action: {
                    showGenogramBuilder = true // Show GenogramBuilder when tapped
                }) {
                    Text("Open Genogram Builder")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                .sheet(isPresented: $showGenogramBuilder) {
                                    GenogramBuilder(genogramData: genogramData, isEditable: true) // Pass genogramData to GenogramBuilder
                }
            }
        }
        .padding()
    }

    // Helper function to create input fields
    private func inputField(label: String, text: Binding<String>) -> some View {
        HStack {
            Text(label + ":")
            TextField("Enter \(label.lowercased())", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
