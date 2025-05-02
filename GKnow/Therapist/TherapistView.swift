import SwiftUI
import SwiftData

// MARK: - Patient Card View
struct PatientListItemView: View {
    
    let patient: Patient
    
    
    var body: some View {
        NavigationLink(destination: PatientInfoInput(isTherapist: true, patient: patient)) {
            HStack {
                Text(formatPatientName(patient))
                    .font(.title2)
                    .foregroundColor(Color("Candace's Couch"))
                    .padding()
                
                Spacer()
                
//                Image(systemName: "chevron.right")
//                    .foregroundColor(Color("Candace's Couch"))
//                    .padding(.trailing)
            }
            .frame(maxWidth: .infinity)
            .background(Color("Anti-flash White"))
            .cornerRadius(10)
        }
    }
    
    private func formatPatientName(_ patient: Patient) -> String {
        let firstName = patient.firstName ?? ""
        let middleName = patient.middleName ?? ""
        let lastName = patient.lastName ?? ""
        return middleName.isEmpty ? "\(firstName) \(lastName)" : "\(firstName) \(middleName) \(lastName)"
    }
}

// MARK: - Header View
struct TherapistHeaderView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Text("Therapist Dashboard")
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
    }
}

// MARK: - Patient List View
struct PatientListView: View {
    var patients: [Patient]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            ForEach(patients) { patient in
                PatientListItemView(patient: patient)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.bottom, 5)
            }
            .onDelete(perform: deletePatients)
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
    }
    
    private func deletePatients(at offsets: IndexSet) {
        for index in offsets {
            let patientToDelete = patients[index]
            modelContext.delete(patientToDelete)
        }
        
        // Save changes
        do {
            try modelContext.save()
        } catch {
            print("Error deleting patient: \(error)")
        }
    }
}

// MARK: - Main View
struct TherapistView: View {
    @Environment(\.modelContext) var context
    @State private var showNewPatientView = false
    @State private var searchText = ""
    
    @Query(sort: \Patient.lastName) var patients: [Patient]
    
    // Computed property for filtered patients
    private var filteredPatients: [Patient] {
        if searchText.isEmpty {
            return patients
        } else {
            return patients.filter { patient in
                let firstName = patient.firstName ?? ""
                let lastName = patient.lastName ?? ""
                return firstName.contains(searchText) || lastName.contains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Main content container
            VStack(spacing: 0) {
                // Header with search
                TherapistHeaderView(searchText: $searchText)
                
                // Main content area
                VStack(alignment: .leading, spacing: 30) {
                    // Welcome text
                    HStack {
                        Text("Select a Patient to View Genogram")
                            .font(.system(size: 48))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Candace's Couch"))
                        Spacer()
                    }
                    
                    // Patient list
                    PatientListView(patients: filteredPatients)
                    
                    // Add patient button
                    addPatientButton
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .background(Color.white.opacity(0.9))
            .cornerRadius(20)
            .padding(20)
        }
        .sheet(isPresented: $showNewPatientView) {
            AddNewPatient { _ in }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - UI Components
    private var addPatientButton: some View {
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
}
