import SwiftUI

struct NewClientView: View {
    @Environment(\.dismiss) var dismiss // Dismiss the sheet when done
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    
    var onSave: (String) -> Void
    
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
        onSave(newClient.trimmingCharacters(in: .whitespaces))
        dismiss()
    }
}

struct NewClientView_Previews: PreviewProvider {
    static var previews: some View {
        NewClientView { _ in }
    }
}
