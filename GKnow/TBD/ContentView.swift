// WE DO NOT USE THIS RN LMFAO

import SwiftUI
import Foundation

// pulls from airtable
struct ContentView: View {
    @StateObject private var patientDataService = PatientDataService()
    let isTherapist: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Client view coming soon")
                    .navigationTitle(isTherapist ? "Therapist Dashboard" : "Client Dashboard")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isTherapist: true)
    }
}
