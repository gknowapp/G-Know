//
//  MainContainerView.swift
//  GKnow
//
//  Created by Curt Leonard on 3/20/25.
//


import SwiftUI

struct MainContainerView: View {
    @State private var activeView: SidebarView.ActiveView = .therapist
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            SidebarView(activeView: $activeView)
            
            // Main content area
            ZStack {
                if activeView == .therapist {
                    TherapistView()
                } else {
                    LearningLibraryView()
                }
            }
        }
        .ignoresSafeArea(.container)
    }
}