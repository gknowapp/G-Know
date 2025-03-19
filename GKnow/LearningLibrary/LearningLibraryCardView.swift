//
//  LearningLibraryCardView.swift
//  GKnow
//
//  Created by Curt Leonard on 3/18/25.
//

import SwiftUI

struct LearningLibraryCardView : View {
    
    let name : String
    let image : String
    let description : String
    
    var body: some View {
        VStack {
            Text(name)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .padding(.bottom, UIHelper.standardPadding / 2)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIHelper.relativeWidth(0.15), height: UIHelper.relativeWidth(0.15))
                .padding(.bottom, UIHelper.standardPadding / 2)
            
            Text(description)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(6)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: UIHelper.relativeWidth(0.18), height: UIHelper.relativeWidth(0.28))
        .padding(UIHelper.standardPadding)
        .clipShape(RoundedRectangle(cornerRadius: UIHelper.standardCornerRadius))
        .border(Color("Dark Green"))
    }
}

#Preview {
    LearningLibraryCardView(name: "Square", image : "Male", description : "A square")
}
