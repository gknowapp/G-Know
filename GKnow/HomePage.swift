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
    
    let backgroundImage = Image("Therapist Background")
        .resizable()
    
    let GKnowLogo = Image("GKnow Logo")
    
    //@Binding var isTherapistView: Bool
    
    
    var body: some View {
        ZStack {
            //Background Image
            HStack {
                backgroundImage
                    .opacity(0.25)
            }
            .overlay(Color ("Overlay"))
            .ignoresSafeArea(.container)
            
            VStack {
                //Logo
                HStack {
                    GKnowLogo
                }
                .frame(height: 450.0)
                .padding(.top, 50)
                
                
                
                // Subtitle
                Text("Genogram Maker")
                    .font(.system(size:72))
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .padding(.bottom, 80)
                    .padding(.top, -70)
                
                // Sign Up Button
                Button(action: {
                    // Handle sign up action
                    showSignup = true
                }) {
                    Text("New to GKnow? Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color ("Candace's Couch"))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color ("Login Box"))
                        .cornerRadius(20)
                        .padding(.horizontal, 400)
                }
                .fullScreenCover(isPresented: $showSignup) {
                    Signup(isHome: $isHome)
                }
                .padding(.bottom, 30)
                .shadow(radius: 10)
                
                // Login Button
                Button(action: {
                    // Handle login action
                    showLogin = true
                }) {
                    Text("Existing User? Login")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color ("Candace's Couch"))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color ("Login Box"))
                        .cornerRadius(20)
                        .padding(.horizontal, 400)
                        
                }
                .fullScreenCover(isPresented: $showLogin) {
                    Login(isHome: $isHome)
                    
                }
                .shadow(radius: 10)
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Disclaimer"),
                    message: Text("The information provided by the GKnow app is for educational and informational purposes only. It is not a substitute for professional advice, diagnosis, or treatment. The app does not account for the full complexity of individual cases, and any insights offered should be considered as general patterns, rather than specific indicators of personal circumstances."),
                    dismissButton: .default(Text("I understand")) {
                        showAlert = false // Dismiss the alert when the button is pressed
                    }
                )
            }
        }
    }
}
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomePage(isHome: .constant(true))
        }
    }

