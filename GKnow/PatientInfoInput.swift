import SwiftUI

struct PatientInfoInput: View {
    let isTherapist: Bool
    let clientName: String
    
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    @State private var age: String = ""
    
    @State private var showPatientCard: Bool = false
    @State private var isEditing: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(isTherapist ? "Client: \(clientName)" : "My Genogram")
                .font(.headline)
            
            Group {
                HStack {
                    Text("First Name:")
                    TextField("Enter first name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(!isEditing) // Disable unless in editing mode
                }
                HStack {
                    Text("Middle Name:")
                    TextField("Enter middle name", text: $middleName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(!isEditing)
                }
                
                HStack {
                    Text("Last Name:")
                    TextField("Enter last name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(!isEditing)
                }
                
                HStack {
                    Text("Age:")
                    TextField("Enter age", text: $age)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .disabled(!isEditing)
                        .onChange(of: age) { newValue in
                            // Validate that age is a number
                            if !newValue.isEmpty && Int(newValue) == nil {
                                showAlert = true
                                age = String(age.dropLast()) // Remove invalid input
                            }
                        }
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                if isEditing {
                    // Save action
                    showPatientCard = true
                } else {
                    // Edit action
                    showPatientCard = false
                }
                isEditing.toggle()
            }) {
                Text(isEditing ? "Save" : isTherapist ? "Edit Client Genogram" : "View My Genogram")
                    .padding()
                    .background(isEditing ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
            
            if showPatientCard {
                PatientCardView(firstName: $firstName, middleName: $middleName, lastName: $lastName, age: $age, isEditing: $isEditing, showPatientCard: $showPatientCard)
                    .padding(.top)
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid Input"), message: Text("Please enter a valid age."), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            populateNamesFromClientName()
        }
    }
    
    private func populateNamesFromClientName() {
        // Split the clientName into components
        let nameComponents = clientName.split(separator: " ")
        
        // Assign values based on the number of components
        if nameComponents.count > 0 {
            firstName = String(nameComponents[0])
        }
        
        if nameComponents.count == 2 {
            lastName = String(nameComponents[1])
        }
        
        if nameComponents.count > 2 {
            middleName = String(nameComponents[1])
            lastName = String(nameComponents[2])
        }
        
        // Clear middle and last names if only one name is provided
        if nameComponents.count == 1 {
            middleName = ""
            lastName = ""
        }
    }
}

struct PatientInfoInput_Previews: PreviewProvider {
    static var previews: some View {
        PatientInfoInput(isTherapist: true, clientName: "John Smith Doe")
    }
}
