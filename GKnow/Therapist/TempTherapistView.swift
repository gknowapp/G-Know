// EmptyTherapistView.swift
// GKnow
//
// Created by Catherine Chu on 10/12/24.
//

import SwiftUI

struct TempTherapistView: View {
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

                Spacer()
                
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
                        // You can refresh the patient list or handle the new patient here
                        // For example: patientDataService.fetchPatients()
                    }
                }
            }
            .padding()
            .navigationTitle("Therapist Dashboard")
        }
    }
}

struct TempTherapistView_Previews: PreviewProvider {
    static var previews: some View {
        TempTherapistView()
    }
}
