//
//  GKnowApp.swift
//  GKnow
//
//  Created by Catherine Chu on 8/29/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct GKnowApp: App {
    @State private var isHome: Bool = true
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
           WindowGroup {
               if isHome {
                   HomePage(isHome: $isHome) // Pass binding to HomePage
               } else {
                   // Navigate to other views as needed
                   HomePage(isHome: $isHome)
               }
           }
       }
   }
