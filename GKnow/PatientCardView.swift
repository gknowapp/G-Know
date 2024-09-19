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
            Text("Patient Details")
                .font(.headline)
                .padding(.bottom, 10)
            
            HStack {
                Text("First Name:")
                Spacer()
                Text(firstName)
            }
            
            HStack {
                Text("Middle Name:")
                Spacer()
                Text(middleName)
            }
            
            HStack {
                Text("Last Name:")
                Spacer()
                Text(lastName)
            }
            
            HStack {
                Text("Age:")
                Spacer()
                Text(age)
            }
            
            Button(action: {
                showPatientCard = false
            }) {
                Text("Delete")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct PatientCardView_Previews: PreviewProvider {
    static var previews: some View {
        PatientCardView(firstName: .constant("John"), middleName: .constant("Doe"), lastName: .constant("Smith"), age: .constant("25"), isEditing: .constant(false), showPatientCard: .constant(true))
    }
}
