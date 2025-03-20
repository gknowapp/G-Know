//
//  EnhancedCardView.swift
//  GKnow
//
//  Created by Curt Leonard on 3/20/25.
//
//

import SwiftUI


// Enhanced card view to match the design in the image
struct EnhancedCardView: View {
    let title: String
    let image: String
    let description: String
    let onReadMore: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            // Title at the top
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            
            // Image in the middle
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIHelper.relativeWidth(0.15), height: UIHelper.relativeWidth(0.15))
                .padding()
                .background(Color.white)
                .cornerRadius(5)
            
            // Description at the bottom
            Text(description.prefix(100) + "...")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
            
            // Read more button
            Button(action: onReadMore) {
                Text("read more")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 10)
        }
        .frame(height: UIHelper.relativeWidth(0.4))
        .background(Color("Dark Green").opacity(0.6))
        .cornerRadius(10)
    }
}
