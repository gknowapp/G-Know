//  TherapistView.swift
//  GKnow
//
//  Created by Catherine Chu on 10/2/24.
//

import SwiftUI

struct TherapistView: View {
    @StateObject private var patientDataService = PatientDataService()
    @State private var showNewPatientView = false

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "testtube.2")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("GKnow!")
                
                Text("Select a Patient to View Genogram")
                    .font(.headline)
                
                List(patientDataService.patients) { patient in
                    // Create the full name here
                    let firstName = patient.fields.firstName ?? ""
                    let middleName = patient.fields.middleName ?? ""
                    let lastName = patient.fields.lastName ?? ""
                    let fullName = middleName.isEmpty ? "\(firstName) \(lastName)" : "\(firstName) \(middleName) \(lastName)"
                    
                    // Pass the correct patient object to PatientInfoInput
                    NavigationLink(destination: PatientInfoInput(isTherapist: true, patient: patient)) {
                        Text(fullName)
                    }
                }
                
                Button(action: {
                    showNewPatientView = true
                }) {
                    Text("Add New Patient")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showNewPatientView) {
                    AddNewPatient { newPatient in
                        patientDataService.fetchPatients() //  refresh the list
                    }
                }
            }
            .padding()
            .navigationTitle("Therapist Dashboard")
        }
        .onAppear {
            patientDataService.fetchPatients()
        }
    }
}

struct TherapistView_Previews: PreviewProvider {
    static var previews: some View {
        TherapistView()
    }
}
