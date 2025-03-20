// Homepage - initial screen users see when they launch the app
// asks users to pick between client and therapist 
import SwiftUI

struct UserTypeSelection: View {
    @State private var navigateToTherapist: Bool = false
    @State private var navigateToClientCode: Bool = false
    //@Binding var isTherapistView: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Select User Type")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: MainContainerView(), isActive: $navigateToTherapist) {
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
