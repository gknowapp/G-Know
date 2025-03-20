//
//  SidebarView.swift
//  GKnow
//
//  Created by Curt Leonard on 3/20/25.
//


import SwiftUI

struct SidebarView: View {
    enum ActiveView {
        case therapist
        case learningLibrary
    }
    
    @Binding var activeView: ActiveView
    
    var body: some View {
        VStack(spacing: 30) {
            // App logo at top
            Image("GKnow Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(.top, 30)
            
            Spacer()
            
            // Home button
            Button(action: {
                activeView = .therapist
            }) {
                Image(systemName: "house.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(activeView == .therapist ? Color("Candace's Couch") : .gray)
            }
            .padding(.vertical, 10)
            
            // Learning Library button
            Button(action: {
                activeView = .learningLibrary
            }) {
                Image(systemName: "book.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(activeView == .learningLibrary ? Color("Candace's Couch") : .gray)
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            // Settings button at bottom
            Button(action: {
                // Settings action
            }) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 30)
        }
        .frame(width: 80)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 3, y: 0)
    }
}