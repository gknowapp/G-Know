//
//  UIHelper.swift
//  GKnow
//
//  Created by Curt Leonard on 2/17/25.
//


import SwiftUI

struct UIHelper {
    // Get current screen dimensions
    static var screenSize: CGSize {
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
                return CGSize(width: 0, height: 0)
        }
        return window.frame.size
    }
    
    // Responsive dimensions
    static func relativeWidth(_ percentage: Double) -> CGFloat {
        return cachedScreenSize.width * CGFloat(percentage)
    }
    
    static func relativeHeight(_ percentage: Double) -> CGFloat {
        return cachedScreenSize.height * CGFloat(percentage)
    }
    
    // Common dimensions with relative sizing
    static var standardIconSize: CGFloat {
        return relativeWidth(0.04) // 4% of screen width
    }
    
    static var standardPadding: CGFloat {
        return relativeWidth(0.02) // 2% of screen width
    }
    
    static var toolbarHeight: CGFloat {
        return relativeHeight(0.07) // 7% of screen height
    }
    static let cachedScreenSize: CGSize = {
        let size = UIScreen.main.bounds.size
        return CGSize(width: max(size.width, size.height),
                      height: min(size.width, size.height))
    }()
    // Common modifiers
    /*static func standardShadow() -> some View {
        return AnyView(
            Shadow(color: .black.opacity(0.2), radius: 10, x: 2, y: 4)
        )
    }*/
    
    static var standardCornerRadius: CGFloat {
        return 10
    }
}
