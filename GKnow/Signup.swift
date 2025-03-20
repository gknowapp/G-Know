// Signup.swift
// GKnow
//
// Created by Catherine Chu on 10/12/24.
//

import Foundation
import SwiftUI
import PhotosUI // Needed for image picker

struct Signup: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isHome: Bool
    @State private var showTherapistSignup = false
    @State private var showPatientSignup = false
    @State private var showTempTherapistView = false // State variable for redirecting

    let backgroundImage = Image("Therapist Background")
        .resizable()
    
    let GKnowLogo = Image("GKnow Logo")
        
    var body: some View {
        ZStack {
            //Background Image
            HStack {
                backgroundImage
                    .opacity(0.25)
            }
            .overlay(Color ("Overlay"))
            VStack {
                // Back button
                Button(action: {
                    dismiss() // Use dismiss() to close the Signup view
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                //Logo
                HStack {
                    GKnowLogo
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: UIHelper.relativeWidth(0.75), height: UIHelper.relativeHeight(0.3))
                .padding(UIHelper.standardPadding)
                
                // Subtitle
                Text("Genogram Maker")
                    .font(.system(size:72))
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .padding(.bottom, 80)
                    .padding(.top, -70)
                    
                
                // Therapist Sign Up Button
                Button(action: {
                    showTherapistSignup.toggle()
                }) {
                    Text("Sign Up as a Therapist")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color ("Candace's Couch"))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color ("Login Box"))
                        .cornerRadius(20)
                        .padding(.horizontal, 400)
                }
                .sheet(isPresented: $showTherapistSignup) {
                    TherapistSignupView(onComplete: {
                        showTempTherapistView = true // Navigate to TempTherapistView
                    })
                }
                .padding(.bottom, 30)
                .shadow(radius: 10)
                
                // Full screen cover for TempTherapistView
                .fullScreenCover(isPresented: $showTempTherapistView) {
                    TempTherapistView()
                }
                
                // Patient Sign Up Button
                    Button(action: {
                        showPatientSignup.toggle()
                    }) {
                        Text("Sign Up as a Patient")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(Color ("Candace's Couch"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color ("Login Box"))
                            .cornerRadius(20)
                            .padding(.horizontal, 400)
                    }
                    .sheet(isPresented: $showPatientSignup) {
                        PatientSignupView() // Placeholder for patient sign-up
                    }
                    .shadow(radius: 10)
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .ignoresSafeArea(.container)
    }
}

// Therapist Sign Up View
import SwiftUI
import PhotosUI

struct TherapistSignupView: View {
    @State private var firstName = ""
    @State private var middleName = ""
    @State private var lastName = ""
    @State private var birthDate = Date()
    @State private var address = ""
    @State private var email = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    var onComplete: () -> Void // Callback for completion

    var body: some View {
        NavigationStack {
            VStack {
                Text("Therapist Sign Up")
                    .font(.largeTitle)
                    .padding()

                Form {
                    // First Name
                    TextField("First Name", text: $firstName)
                    // Middle Name
                    TextField("Middle Name", text: $middleName)
                    // Last Name
                    TextField("Last Name", text: $lastName)
                    
                    // Birth Date Picker
                    DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                    
                    // Address
                    TextField("Address", text: $address)
                    
                    // Email
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    // Image Picker
                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Text("Upload Profile Image")
                    }
                    .onChange(of: selectedImage) { newItem in
                        if let newItem = newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    profileImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                    }
                    
                    // Display the selected image
                    if let profileImage = profileImage {
                        profileImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle()) // Display image as a circle
                            .padding()
                    } else {
                        Text("No Profile Image Selected")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                // Complete Signup Button
                Button(action: {
                    onComplete() // Call the onComplete closure to navigate
                }) {
                    Text("Complete Signup")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding()

                Spacer()
            }
            .padding()
        }
    }
}

// Patient Sign Up View - Placeholder
struct PatientSignupView: View {
    var body: some View {
        Text("Patient Sign Up")
            .font(.largeTitle)
            .padding()
        Spacer()
    }
}

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup(isHome: .constant(false))
    }
}
