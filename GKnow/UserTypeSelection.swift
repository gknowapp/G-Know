import SwiftUI

struct UserTypeSelection: View {
    @State private var navigateToTherapist: Bool = false
    @State private var navigateToClientCode: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Select User Type")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: ContentView(isTherapist: true), isActive: $navigateToTherapist) {
                    EmptyView()
                }

                NavigationLink(destination: ClientCodeEntryView(), isActive: $navigateToClientCode) {
                    EmptyView()
                }
                
                Button(action: {
                    navigateToTherapist = true
                }) {
                    Text("Therapist")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    navigateToClientCode = true
                }) {
                    Text("Client")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Welcome")
        }
    }
}
