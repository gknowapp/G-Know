import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Patient.createdAt, ascending: false)],
        animation: .default)
    private var patients: FetchedResults<Patient>
    
    @State private var showingAddPatient = false
    @State private var selectedPatient: Patient?
    @State private var newPatientName = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(patients) { patient in
                    NavigationLink(destination: PatientDetailView(patient: patient)) {
                        Text(patient.name ?? "Unnamed Patient")
                    }
                }
                .onDelete(perform: deletePatients)
            }
            .navigationTitle("Patients")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPatient = true }) {
                        Label("Add Patient", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPatient) {
                NavigationView {
                    Form {
                        TextField("Patient Name", text: $newPatientName)
                    }
                    .navigationTitle("New Patient")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            showingAddPatient = false
                            newPatientName = ""
                        },
                        trailing: Button("Add") {
                            addPatient()
                        }
                    )
                }
            }
        }
    }
    
    private func addPatient() {
        withAnimation {
            let patient = CoreDataManager.shared.createPatient(name: newPatientName)
            newPatientName = ""
            showingAddPatient = false
        }
    }
    
    private func deletePatients(offsets: IndexSet) {
        withAnimation {
            offsets.map { patients[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

struct PatientDetailView: View {
    @ObservedObject var patient: Patient
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddGenogram = false
    
    var body: some View {
        List {
            ForEach(patient.genograms?.allObjects as? [Genogram] ?? []) { genogram in
                NavigationLink(destination: GenogramBuilder(genogram: genogram, selectedIcon: .constant(nil), isSidePanelVisible: .constant(false), patientName: patient.name ?? "Patient")) {
                    Text("Genogram \(genogram.createdAt?.formatted() ?? "")")
                }
            }
            .onDelete(perform: deleteGenograms)
        }
        .navigationTitle(patient.name ?? "Patient")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddGenogram = true }) {
                    Label("Add Genogram", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddGenogram) {
            NavigationView {
                GenogramBuilder(
                    genogram: CoreDataManager.shared.createGenogram(for: patient),
                    selectedIcon: .constant(nil),
                    isSidePanelVisible: .constant(false),
                    patientName: patient.name ?? "Patient"
                )
                .navigationBarItems(trailing: Button("Done") {
                    showingAddGenogram = false
                })
            }
        }
    }
    
    private func deleteGenograms(offsets: IndexSet) {
        withAnimation {
            if let genograms = patient.genograms?.allObjects as? [Genogram] {
                offsets.map { genograms[$0] }.forEach(viewContext.delete)
                try? viewContext.save()
            }
        }
    }
} 