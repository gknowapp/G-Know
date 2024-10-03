// when therapist adds new client
import SwiftUI

struct NewClientView: View {
    @Environment(\.dismiss) var dismiss
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    
    var onSave: (String) -> Void
    private let airtableService = AirTableService() // Instantiate the Airtable service

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add New Client")
                    .font(.headline)
                
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Middle Name", text: $middleName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: saveClient) {
                    Text("Save")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Client")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveClient() {
        let newClient = "\(firstName) \(middleName) \(lastName)"
        let trimmedClient = newClient.trimmingCharacters(in: .whitespaces)

        airtableService.addClient(firstName: firstName, middleName: middleName, lastName: lastName) { success in
            if success {
                DispatchQueue.main.async {
                    onSave(trimmedClient)
                    dismiss()
                }
            } else {
                // Handle error (e.g., show an alert)
                print("Error saving client.")
            }
        }
    }
}

struct NewClientView_Previews: PreviewProvider {
    static var previews: some View {
        NewClientView { _ in }
    }
}
