//
//  HomePage.swift
//  GKnow
//
//  Created by Catherine Chu on 10/10/24.
//

import SwiftUI

struct HomePage: View {
    @Binding var isHome: Bool
    @State private var showAlert = true
    @State private var showSignup = false
    @State private var showLogin = false


        var body: some View {
            VStack {
                // Title
                Text("GKNow")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                // Subtitle
                Text("Genogram Maker")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.bottom, 50)

                // Sign Up Button
                Button(action: {
                    // Handle sign up action
                    showSignup = true
                }) {
                    Text("New to GKnow? Sign Up")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
                .fullScreenCover(isPresented: $showSignup) {
                    Signup(isHome: $isHome)
                }

                // Login Button
                Button(action: {
                    // Handle login action
                    showLogin = true
                }) {
                    Text("Existing User? Log In")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
                .fullScreenCover(isPresented: $showLogin) {
                    Login(isHome: $isHome)
                }

                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Disclaimer"),
                    message: Text("The information provided by the GKnow app is for educational and informational purposes only. It is not a substitute for professional advice, diagnosis, or treatment. The app does not account for the full complexity of individual cases, and any insights offered should be considered as general patterns, rather than specific indicators of personal circumstances."),
                    dismissButton: .default(Text("I understand.")) {
                        showAlert = false // Dismiss the alert when the button is pressed
                    }
                )
            }
        }
    }

    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomePage(isHome: .constant(true))
        }
    }
