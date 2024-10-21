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
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()
    
    
    
    var body: some View {
            VStack(alignment: .leading, spacing: 15){
                Text("Patient Card")
                    .font(.largeTitle)
                Text("First: \(firstName)")
                    .font(.title2)
                Text("Middle: \(middleName)")
                    .font(.title2)
                Text("Last: \(lastName)")
                    .font(.title2)
                Text("DOB: \(iso8601Formatter.string(from: dob))") // Format the date
                    .font(.title2)
                
                // Display role(s)
                if !role.isEmpty {
                    Text("Role: \(role.joined(separator: ", "))") // Join roles into a single string
                        .font(.title2)
                } else {
                    Text("Role: None") // Handle empty role
                        .font(.title2)
                }
                
                // Display birth order(s)
                if !birthOrder.isEmpty {
                    Text("Birth Order: \(birthOrder.joined(separator: ", "))") // Join birth orders into a single string
                        .font(.title2)
                } else {
                    Text("Birth Order: None") // Handle empty birth order
                        .font(.title2)
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
            .frame(width: 400, height: 300 , alignment: .leading)
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(CGFloat(25))
            //.padding(.vertical, 50)
            .background(Color ("Anti-flash White"))
            .cornerRadius(10)
            .shadow(radius: 10)
        }
        
    }

