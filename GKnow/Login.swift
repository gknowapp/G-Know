//
//  Login.swift
//  GKnow
//
//  Created by Catherine Chu on 10/10/24.
//
// Login.swift
import SwiftUI

struct Login: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isHome: Bool // Binding to control navigation back to home
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToTherapist = false
    
    // Hardcoded for now
    let validUsername = "Candacecouch"
    let validPassword = "password"

    var body: some View {
        NavigationView { // Ensure NavigationView is present in both environments
            VStack {
                // Back Button
                Button(action: {
                    dismiss() // Dismiss the view
                    isHome = true // Update isHome to trigger navigation back home
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Title
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                // Email Field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Password Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Login Button
                Button(action: {
                    if email.isEmpty || password.isEmpty {
                        alertMessage = "Please fill in both fields."
                        showAlert = true
                    } else if email == validUsername && password == validPassword {
                        // If credentials are correct, navigate to the TherapistView
                        print("Logging in with \(email) and \(password)")
                        navigateToTherapist = true
                    } else {
                        // Show error if credentials are wrong
                        alertMessage = "Invalid email or password. Please try again."
                        showAlert = true
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // NavigationLink to TherapistView
                NavigationLink(destination: TherapistView(), isActive: $navigateToTherapist) {
                    EmptyView() // Hidden link
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        // Use a constant for isHome binding in the preview
        Login(isHome: .constant(false))
    }
}
