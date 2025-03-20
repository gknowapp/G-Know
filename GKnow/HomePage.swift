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
        NavigationStack {
            ZStack {
                // Clean white background
                Color("Anti-flash White").ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Logo
                    Image("GKnow Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIHelper.relativeWidth(0.7))
                        .padding(.top, UIHelper.relativeHeight(0.1))
                    
                    Spacer()
                    
                    // User type selection buttons
                    VStack(spacing: 20) {
                        Button(action: {
                            showLogin = true
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: UIHelper.relativeWidth(0.6), height: 60)
                                .background(Color("Dark Green"))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            showSignup = true
                        }) {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(Color("Dark Green"))
                                .frame(width: UIHelper.relativeWidth(0.6), height: 60)
                                .background(Color("Light Green"))
                                .cornerRadius(10)
                        }
                    }
                    
                    Spacer()
                    
                    // Footer text
                    Text("© 2025 GKnow")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
                .padding()
            }
            .navigationDestination(isPresented: $showLogin) {
                Login(isHome: $isHome)
            }
            .navigationDestination(isPresented: $showSignup) {
                Signup(isHome: $isHome)
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
        .environment(\.font, Font.custom("Satoshi-Variable", size: 20, relativeTo: .caption))
        .navigationBarHidden(true)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(isHome: .constant(true))
    }
}

