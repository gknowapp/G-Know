import SwiftUI

struct TherapistView: View {
    @StateObject private var patientDataService = PatientDataService()
    @State private var showNewPatientView = false
    @State private var searchText = ""
    
    let backgroundImage = Image("Therapist Background")
        .resizable()
    
    var body: some View {
        ZStack {
            // Background
            backgroundImage
                .opacity(0.25)
                .overlay(Color("Overlay"))
                .ignoresSafeArea(.container)
            
            VStack(spacing: 0) {
                // Header with search bar
                HStack {
                    Text("Learning Library")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("search", text: $searchText)
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(width: UIHelper.relativeWidth(0.3))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                // Main content
                VStack(alignment: .leading, spacing: 30) {
                    // Welcome text
                    Text("Hello, Candace")
                        .font(.system(size: 48))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Candace's Couch"))
                    
                    Text("Select a Patient to View Genogram")
                        .font(.headline)
                        .foregroundColor(Color("Candace's Couch"))
                        .padding(.top, 20)
                    
                    // Patient list
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(patientDataService.patients) { patient in
                                // Create the full name
                                let firstName = patient.fields.firstName ?? ""
                                let middleName = patient.fields.middleName ?? ""
                                let lastName = patient.fields.lastName ?? ""
                                let fullName = middleName.isEmpty ? "\(firstName) \(lastName)" : "\(firstName) \(middleName) \(lastName)"
                                
                                // Patient card
                                NavigationLink(destination: PatientInfoInput(isTherapist: true, patient: patient)) {
                                    HStack {
                                        Text(fullName)
                                            .font(.title2)
                                            .foregroundColor(Color("Candace's Couch"))
                                            .padding()
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color("Candace's Couch"))
                                            .padding(.trailing)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(Color("Anti-flash White"))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    
                    // Add new patient button
                    Button(action: {
                        showNewPatientView = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("Add New Patient")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("Candace's Couch"))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .background(Color.white.opacity(0.9))
            .cornerRadius(20)
            .padding(20)
        }
        .sheet(isPresented: $showNewPatientView) {
            AddNewPatient { newPatient in
                patientDataService.fetchPatients() // Refresh the list
            }
        }
        .onAppear {
            patientDataService.fetchPatients()
        }
        .navigationBarHidden(true)
    }
}
