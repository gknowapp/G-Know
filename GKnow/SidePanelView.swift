import SwiftUI

struct SidePanelView: View {
    var iconName: String
    var description: String
    var onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Selected Icon:")
                .font(.headline)
            Image(iconName)
                .resizable()
                .frame(width: 100, height: 100)
            Text(description)
                .foregroundColor(.gray)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            Spacer()

            // Close button
            Button(action: {
                onClose()
            }) {
                Text("Close")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .frame(width: 300)
    }
}
