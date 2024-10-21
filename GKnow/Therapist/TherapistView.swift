//  TherapistView.swift
//  GKnow
//
//  Created by Catherine Chu on 10/2/24.
//

import SwiftUI

struct TherapistView: View {
    @StateObject private var patientDataService = PatientDataService()
    @State private var showNewPatientView = false
    
    let backgroundImage = Image("Therapist Background")
        .resizable()
    

    var body: some View {
            NavigationStack {
                ZStack {
                    //Background Image
                    HStack {
                        backgroundImage
                            .opacity(0.25)
                    }
                    .overlay(Color ("Overlay"))
                    .ignoresSafeArea(.container)
                    
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            Spacer()
                            Spacer()
                            Text("Hello, Candace")
                                .font(.system(size: 72))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Candace's Couch"))
                                .padding(.top, 50)
                                //.padding(.bottom, 10)
                            
                            Spacer()
                            Spacer()
                            Button(action: {
                                showNewPatientView = true
                            }) {
                                Text("+")
                                    .font(.system(size: 72))
                                    .padding()
                                    .foregroundColor(Color ("Candace's Couch"))
                                    .cornerRadius(10)
                                    .padding(.trailing, 50)
                            }
                            
                        }
                        
                        //Image(systemName: "testtube.2")
                           // .imageScale(.large)
                        //.foregroundColor(.accentColor)
                        //Text("GKnow!")
                        
                            
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
                                .listRowBackground(Color ("Anti-flash White"))
                                .foregroundStyle(Color ("Candace's Couch"))
                                .font(.title)
                                .padding(.vertical, 10)
                            }
                            
                            
                            .cornerRadius(20)
                            .background(Color ("Dark Green"))
                            .scrollContentBackground(.hidden)
                            
                        
                        
                            .sheet(isPresented: $showNewPatientView) {
                            AddNewPatient { newPatient in
                                patientDataService.fetchPatients() //  refresh the list
                            }
                        }
                        .padding(CGFloat(30))
                        .padding([.horizontal, .bottom], 50)
                        .shadow(radius: 20)
                        
                    }
                    Text("Select a Patient to View Genogram")
                        .font(.headline)
                        .foregroundColor(Color("Candace's Couch"))
                        .padding(.top, 50)
                        
                        
                }
                
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
