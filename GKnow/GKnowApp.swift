//
//  GKnowApp.swift
//  GKnow
//
//  Created by Catherine Chu on 8/29/24.
//

import SwiftUI

@main
struct GKnowApp: App {
    @State private var isHome: Bool = true
    var body: some Scene {
           WindowGroup {
               if isHome {
                   HomePage(isHome: $isHome) // Pass binding to HomePage
                       .environment(\.font, Font.custom("Satoshi-Variable", size: 20, relativeTo: .caption))
               } else {
                   // Navigate to other views as needed
                   MainContainerView()
                       .environment(\.font, Font.custom("Satoshi-Variable", size: 20, relativeTo: .caption))
               }
           }
       }
   }
