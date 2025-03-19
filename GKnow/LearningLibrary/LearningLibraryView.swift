//
//  LearningLibraryView.swift
//  GKnow
//
//  Created by Curt Leonard on 3/18/25.
//

import SwiftUI

struct LearningLibraryView: View {
    var body: some View {
        
        VStack(alignment: .center) {
            Text("Learning Library")
                .font(.headline)
            
            Spacer()
            
            ScrollView {
                Grid {
                    
                    GridRow {
                        
                        Text("1")
                        Text("2")
                        Text("3")
                    }
                    
                    GridRow {
                        
                        Text("2")
                    }
                    
                    GridRow {
                        
                        Text("3")
                    }
                }
            }
            
            
        } // Main VStack
        
        
      
    }
}



#Preview {
    LearningLibraryView()
}

