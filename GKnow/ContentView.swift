import SwiftUI

struct ContentView: View {
    let isTherapist: Bool
    
    // Dynamic client data
    @State private var clients = ["John Smith Doe"]
    @State private var showNewClientView = false
    
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
                    
                    Button(action: {
                        showNewClientView = true
                    }) {
                        Text("Add New Client")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $showNewClientView) {
                        NewClientView { newClient in
                            clients.append(newClient)
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
