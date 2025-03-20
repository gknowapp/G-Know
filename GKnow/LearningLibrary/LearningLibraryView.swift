//
//  LearningLibraryView.swift
//  GKnow
//
//  Created by Curt Leonard on 3/18/25.
//

import SwiftUI

struct LearningLibraryView: View {
    // Create instances of the content structs
    let symbols = LibraryContents.symbolNames()
    let relationships = LibraryContents.relationships()
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Learning Library")
                .font(.headline)
            
            Spacer()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Symbols")
                        .font(.title2)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: UIHelper.relativeWidth(0.20), maximum: UIHelper.relativeWidth(0.25)), spacing: 16)
                    ], spacing: 16) {
                        // Symbol cards
                        LearningLibraryCardView(name: symbols.male[0], image: symbols.male[1], description: symbols.male[2])
                        LearningLibraryCardView(name: symbols.female[0], image: symbols.female[1], description: symbols.female[2])
                        LearningLibraryCardView(name: symbols.abortion[0], image: symbols.abortion[1], description: symbols.abortion[2])
                        LearningLibraryCardView(name: symbols.pregancy[0], image: symbols.pregancy[1], description: symbols.pregancy[2])
                        LearningLibraryCardView(name: symbols.miscarriage[0], image: symbols.miscarriage[1], description: symbols.miscarriage[2])
                    }
                    .padding(.horizontal)
                    
                    Text("Relationships")
                        .font(.title2)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: UIHelper.relativeWidth(0.20), maximum: UIHelper.relativeWidth(0.25)), spacing: 16)
                    ], spacing: 16) {
                        // Relationship cards
                        LearningLibraryCardView(name: relationships.marriage[0], image: relationships.marriage[1], description: relationships.marriage[2])
                        LearningLibraryCardView(name: relationships.child[0], image: relationships.child[1], description: relationships.child[2])
                        LearningLibraryCardView(name: relationships.abuse[0], image: relationships.abuse[1], description: relationships.abuse[2])
                        LearningLibraryCardView(name: relationships.harmony[0], image: relationships.harmony[1], description: relationships.harmony[2])
                        LearningLibraryCardView(name: relationships.friendship[0], image: relationships.friendship[1], description: relationships.friendship[2])
                        LearningLibraryCardView(name: relationships.fusion[0], image: relationships.fusion[1], description: relationships.fusion[2])
                        LearningLibraryCardView(name: relationships.focus[0], image: relationships.focus[1], description: relationships.focus[2])
                        LearningLibraryCardView(name: relationships.dating[0], image: relationships.dating[1], description: relationships.dating[2])
                        LearningLibraryCardView(name: relationships.affair[0], image: relationships.affair[1], description: relationships.affair[2])
                        LearningLibraryCardView(name: relationships.divorce[0], image: relationships.divorce[1], description: relationships.divorce[2])
                    }
                    .padding(.horizontal)
                }
            }
        } // Main VStack
        .padding()
    }
}

#Preview {
    LearningLibraryView()
}

