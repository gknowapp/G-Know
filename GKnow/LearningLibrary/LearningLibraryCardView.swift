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
            Image(image)
                .resizable()
                //.aspectRatio(.fill, contentMode: <#ContentMode#>)
                .frame(width: 100, height: 100)
            Text(description)
        }
        .padding(UIHelper.standardPadding)
        .clipShape(RoundedRectangle(cornerSize: (CGSize(width: 5, height: 5))))
        .border(Color("Dark Green"))
    }
}

#Preview {
    LearningLibraryCardView(name: "Square", image : "Male", description : "A square")
}
