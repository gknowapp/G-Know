//
//  LibraryDetailView.swift
//  GKnow
//
//  Created by Curt Leonard on 3/20/25.
//
//

import SwiftUI


// Detail view that appears when "read more" is tapped
struct LibraryDetailView: View {
    let item: LibraryItem
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Light green background for the entire view
            //Color(.systemGray6).opacity(0.5)
                //.ignoresSafeArea()
            
            // Content card
            HStack {
            
                VStack(alignment: .leading, spacing: 20) {
                    // Back button
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("back")
                                .foregroundColor(.black)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                    
                    // Main content area with gradient background
                    HStack(alignment: .top, spacing: 20) {
                        // Left side - Title and Image
                        
                        VStack(alignment: .center, spacing: 20) {
                            
                            Text(item.title)
                                .font(.title)
                                .fontWeight(.bold)
                            if (item.image != nil) {
                                Image(item.image!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIHelper.relativeWidth(0.15), height: UIHelper.relativeWidth(0.15))
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: UIHelper.standardCornerRadius)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                
                            }
                        }
                        .frame(width: UIHelper.relativeWidth(0.2))
                        Spacer()
                        // Right side - Detailed description with scroll view
                        ScrollView {
                            
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    // Main description paragraph
                                    HStack {
                                        
                                    Text(item.description)
                                    Spacer()
                                }
                                .padding(.trailing, 10)
                            }
                        }
                        .padding(15)
                        .background(Color("Anti-flash White"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                    .padding(20)
                    
                    .cornerRadius(10)
                }
                
                .padding(20)
            }
            
        }
        .background(LinearGradient(colors: [Color("Light Green"), Color("Anti-flash White")], startPoint: .topLeading, endPoint: .bottomTrailing))
        //.ignoresSafeArea(.all)
        .frame(width: UIHelper.relativeWidth(0.95), height: UIHelper.relativeHeight(1))
        Spacer()
       
    }
}
