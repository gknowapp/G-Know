import SwiftUI

struct ClientCodeEntryView: View {
    @State private var code: String = ""
    @State private var invalidCodeAlert: Bool = false
    @State private var isConnected: Bool = false
    
    let validCode = "THERAPIST123" // Example of a valid code

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Therapist Code")
                .font(.headline)
            
            TextField("Therapist Code", text: $code)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                if code == validCode {
                    isConnected = true
                } else {
                    invalidCodeAlert = true
                }
            }) {
                Text("Connect")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .alert(isPresented: $invalidCodeAlert) {
                Alert(title: Text("Invalid Code"), message: Text("Please enter a valid code to connect to your therapist."), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
            
            // Navigation to ContentView if connected
            NavigationLink(destination: ContentView(isTherapist: false), isActive: $isConnected) {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Client")
    }
}
