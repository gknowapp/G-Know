import SwiftUI

struct PatientCardView: View {
    @Binding var firstName: String
    @Binding var middleName: String
    @Binding var lastName: String
    @Binding var age: String
    @Binding var isEditing: Bool
    @Binding var showPatientCard: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Patient Card")
                .font(.headline)
            Text("First: \(firstName)")
            Text("Middle: \(middleName)")
            Text("Last:  \(lastName)")
            Text("Age: \(age)")
            
            HStack {
                Button(action: {
                    isEditing = true // Set to editing mode
                }) {
                    Text("Edit")
                        .padding(10)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Clear the card
                    firstName = ""
                    middleName = ""
                    lastName = ""
                    age = ""
                    showPatientCard = false
                }) {
                    Text("Delete")
                        .padding(10)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
