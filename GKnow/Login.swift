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
    @Binding var isHome: Bool
    @State private var email: String = "Candacecouch"
    @State private var password: String = "password"
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToTherapist = false
    
    // Hardcoded for now
    let validUsername = "Candacecouch"
    let validPassword = "password"
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background - clean white
                Color("Anti-flash White").ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Logo
                    Image("GKnow Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIHelper.relativeWidth(0.5))
                        .padding(.top, UIHelper.relativeHeight(0.1))
                    
                    Spacer()
                    
                    // Login Form
                    VStack(spacing: 20) {
                        // Username field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username")
                                .font(.headline)
                                .foregroundColor(Color("Dark Green"))
                            
                            TextField("Enter your username", text: $email)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .frame(width: UIHelper.relativeWidth(0.6))
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(Color("Dark Green"))
                            
                            SecureField("Enter your password", text: $password)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .frame(width: UIHelper.relativeWidth(0.6))
                        }
                        
                        // Login button
                        Button(action: {
                            if email == validUsername && password == validPassword {
                                isHome = false
                                navigateToTherapist = true
                            } else {
                                alertMessage = "Invalid username or password"
                                showAlert = true
                            }
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: UIHelper.relativeWidth(0.6))
                                .background(Color("Dark Green"))
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Back to home option
                    Button(action: {
                        dismiss()
                        isHome = true
                    }) {
                        Text("Back to Home")
                            .foregroundColor(Color("Dark Green"))
                    }
                    .padding(.bottom, 30)
                    
                    // NavigationLink to MainContainerView
                    NavigationLink(destination: MainContainerView(), isActive: $navigateToTherapist) {
                        EmptyView()
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        // Use a constant for isHome binding in the preview
        Login(isHome: .constant(false))
    }
}
