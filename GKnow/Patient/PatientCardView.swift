import SwiftUI

struct PatientCardView: View {
    @Binding var firstName: String
    @Binding var middleName: String
    @Binding var lastName: String
    
    @Binding var dob: Date
    @Binding var role: [String]
    @Binding var birthOrder: [String]
    
    @Binding var isEditing: Bool
    @Binding var showPatientCard: Bool
    
    private let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Patient Card")
                .font(.headline)
            Text("First: \(firstName)")
            Text("Middle: \(middleName)")
            Text("Last: \(lastName)")
            Text("DOB: \(iso8601Formatter.string(from: dob))") // Format the date

            // Display role(s)
            if !role.isEmpty {
                Text("Role: \(role.joined(separator: ", "))") // Join roles into a single string
            } else {
                Text("Role: None") // Handle empty role
            }
            
            // Display birth order(s)
            if !birthOrder.isEmpty {
                Text("Birth Order: \(birthOrder.joined(separator: ", "))") // Join birth orders into a single string
            } else {
                Text("Birth Order: None") // Handle empty birth order
            }
            
            /* Uncomment if you need editing and delete buttons
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
            } */
            //.padding(.top, 10)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
