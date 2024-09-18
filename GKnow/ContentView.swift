import SwiftUI

struct ContentView: View {
    let isTherapist: Bool
    
    // Example client data
    let clients = ["Client 1", "Client 2", "Client 3"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "testtube.2")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("GKnow!")
                
                if isTherapist {
                    Text("Select a Client to View Genogram")
                        .font(.headline)
                    
                    List(clients, id: \.self) { client in
                        NavigationLink(destination: PatientInfoInput(isTherapist: true, clientName: client)) {
                            Text(client)
                        }
                    }
                } else {
                    NavigationLink(destination: PatientInfoInput(isTherapist: false, clientName: "My Genogram")) {
                        Text("View My Genogram")
                            .font(.custom("Silkscreen-Regular", size: 20))
                            .padding(10)
                    }
                }
            }
            .padding()
            .navigationTitle(isTherapist ? "Therapist Dashboard" : "Client Dashboard")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isTherapist: true)
    }
}
