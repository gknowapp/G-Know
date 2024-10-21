import SwiftUI

struct SidePanelView: View {
    var iconName: String
    var description: String
    var onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Selected Icon:")
                .font(.headline)

            Image(iconName)
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            Text("Icon Name: \(iconName)")
                .font(.subheadline)
                .bold()

            Text("Description: \(description)")
                .foregroundColor(.gray)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            Spacer()

            // Back button
            Button(action: {
                onClose()
            }) {
                Text("Back")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(width: 300)
    }
}

