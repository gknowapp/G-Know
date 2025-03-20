//
//  GenogramSymbolNotes.swift
//  GKnow
//
//  Created by Curt Leonard on 3/19/25.
//
//

import SwiftUI

struct GenogramSymbolNotes: View {
    @Binding var shape: GenogramShape
    //@Binding var selectedShapeID : UUID?
    
    var body: some View {
       VStack {
           NavigationStack {
               
           
               HStack(alignment: .center) {
                   
                   Text("Symbol Notes")
                       .font(.headline)
                       .padding()
                   
                   
                   NavigationLink(destination: LearningLibraryView()) {
                       
                       Image(systemName: "book.fill")
                       
                   }
                   
                   
                   Button(action: {
                       //edit mode goes here  
                   } ) {
                       
                       Image(systemName: "pencil.circle")
                       
                       
                   }
                   
                   
                   
               }
               
           }
           
           
           HStack {
               
               Text("Name: ")
               Spacer()
               TextEditor(text: $shape.personName)
                   .lineLimit(1)
                  
                   .overlay(RoundedRectangle(cornerRadius: UIHelper.standardCornerRadius)
                       .stroke(Color.secondary).opacity(0.5))

                   .padding(4)
                   
               
           }
           .frame(maxWidth: .infinity, maxHeight: UIHelper.relativeHeight(0.05))
           .padding()
           .background(Color.gray.opacity(0.2))
           
           
            
           
           Image(shape.imageName)
               .padding()
               .frame(width: 100, height: 100)
           
           HStack {
               Text("Notes: ")
               TextEditor(text: $shape.notes)
                   .lineLimit(4)
                   .padding(4)
                   .overlay(RoundedRectangle(cornerRadius: UIHelper.standardCornerRadius)
                       .stroke(Color.secondary).opacity(0.5))
           }
           .padding()
           
        }
       .background(Color.gray.opacity(0.5))
    }
}

#Preview {
   // @Binding var exData =
    //GenogramSymbolNotes(shape: GenogramShape(id: UUID(), imageName: "Male", personName: "Mark", position: CGPoint(x: 100, y: 100), notes: "This is the selected patient's notes."))
}
