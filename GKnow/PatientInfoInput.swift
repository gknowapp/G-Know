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
                        .disabled(isTherapist && !isEditing) // Disable for therapist unless editing
                }
                HStack {
                    Text("Middle Name:")
                    TextField("Enter middle name", text: $middleName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(isTherapist && !isEditing)
                }
                
                HStack {
                    Text("Last Name:")
                    TextField("Enter last name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(isTherapist && !isEditing)
                }
                
                HStack {
                    Text("Age:")
                    TextField("Enter age", text: $age)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .disabled(isTherapist && !isEditing)
                        .onChange(of: age) { newValue in
                            if !newValue.isEmpty && Int(newValue) == nil {
                                showAlert = true
                                age = String(age.dropLast())
                            }
                        }
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                isEditing.toggle()
                showPatientCard.toggle()
            }) {
                Text(isEditing ? "Save" : isTherapist ? "Edit Client Genogram" : "View My Genogram")
                    .padding()
                    .background(Color.blue)
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
    }
}

struct PatientInfoInput_Previews: PreviewProvider {
    static var previews: some View {
        PatientInfoInput(isTherapist: true, clientName: "Client 1")
    }
}
