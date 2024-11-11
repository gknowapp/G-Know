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
    
    let backgroundImage = Image("Therapist Background")
        .resizable()
    
    let GKnowLogo = Image("GKnow Logo")
    
    //@Binding var isTherapistView: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                //Background Image
                HStack {
                    backgroundImage
                        .opacity(0.25)
                }
                .overlay(Color ("Overlay"))
                .ignoresSafeArea(.container)
                
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
                    
                    //Logo
                    HStack {
                        GKnowLogo
                    }
                    .frame(height: 450.0)
                    .padding(.top, -20)
                    
                    // Subtitle
                    Text("Genogram Maker")
                        .font(.system(size:72))
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                        .padding(.bottom, 50)
                        .padding(.top, -70)
                    
                    // Email Field
                    TextField("Username", text: $email)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color ("Candace's Couch"))
                        .padding()
                        .background(Color ("Login Box"))
                        .cornerRadius(10)
                        .padding(.horizontal, 400)
                        .padding(.bottom, 20)
                        .shadow(radius: 10)
                    
                    // Password Field
                    SecureField("Password", text: $password)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color ("Candace's Couch"))
                        .padding()
                        .background(Color ("Login Box"))
                        .cornerRadius(10)
                        .padding(.horizontal, 400)
                        .padding(.bottom, 15)
                        .shadow(radius: 10)
                    
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
                            alertMessage = "Invalid username or password. Please try again."
                            showAlert = true
                        }
                    }) {
                        Text("Login")
                            .font(.largeTitle)
                            .foregroundColor(Color ("Candace's Couch"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color ("Light Green"))
                            .cornerRadius(20)
                            .padding(.horizontal, 450)
                            .padding(.top, 50)
                            .shadow(radius: 10)
                    }
                    
                    // NavigationLink to TherapistView
                    NavigationLink(destination: TherapistView(), isActive: $navigateToTherapist) {
                        EmptyView() // Hidden link
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                //.navigationBarHidden(true)
            }
        } // Hide the navigation bar
            
        }
    }

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        // Use a constant for isHome binding in the preview
        Login(isHome: .constant(false))
    }
}
