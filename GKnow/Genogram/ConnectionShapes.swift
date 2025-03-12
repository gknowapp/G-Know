//
//  ConnectionShapes.swift
//  GKnow
//
//  Created by Curt Leonard on 3/12/25.
//

import Foundation

//
// MARK: Connection Struct
//

struct Connection: Identifiable {
    let id: UUID
    var start: CGPoint?
    var end: CGPoint?
    let startSymbolId: UUID
    let endSymbolId: UUID
    let type: ConnectionType
    var parentConnectionId: UUID?
    
    enum ConnectionType {
        case marriage
        case child
        case abuse
        case harmony
        case frienship
        case fusion
        case divorce
        case focus
        case dating
        case affair
    }
    
    var parentMiddlePoint: CGPoint? {
        guard let start = start, let end = end else { return nil }
        return CGPoint(x: (start.x + end.x) / 2, y: start.y)
    }
}

//
// MARK: Child Connection Line
//

struct ChildConnectionLine: Shape {
    let startPoint: CGPoint
    let childPoint: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start from the point on marriage line
        path.move(to: startPoint)
        
        // Calculate the midpoint between start and child
        let midY = startPoint.y + ((childPoint.y - startPoint.y) / 2)
        
        // Draw vertical line to midpoint
        path.addLine(to: CGPoint(x: startPoint.x, y: midY))
        
        // Draw horizontal line to align with child
        path.addLine(to: CGPoint(x: childPoint.x, y: midY))
        
        // Draw final vertical line to child
        path.addLine(to: childPoint)
        
        return path
    }
}

//
// MARK: Marriage Connection Line
//

struct MarriageConnectionLine: Shape {
    let start: CGPoint
    let end: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 20 // Vertical spacing for marriage connection
        
        // Start point
        path.move(to: start)
        // Down from start
        path.addLine(to: CGPoint(x: start.x, y: start.y + spacing))
        // Horizontal connection
        path.addLine(to: CGPoint(x: end.x, y: start.y + spacing))
        // Up to end
        path.addLine(to: end)
        
        return path
    }
}

//
// MARK: Abuse Connection Line
//

struct AbuseConnectionLine: Shape {
    let start: CGPoint
    let end: CGPoint
    var segments: Int = 12// Number of zigzag segments
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Calculate direction vector
        let dx = end.x - start.x
        let dy = end.y - start.y
        let distance = sqrt(dx * dx + dy * dy)
        
        
        // Calculate unit vector
        let ux = dx / distance
        let uy = dy / distance
        
        // Calculate perpendicular unit vector for zigzag
        let px = -uy
        let py = ux
        
        // Start the path
        path.move(to: start)
        
        let arrowLength: CGFloat = 60 // Increased to ensure visibility
        let arrowBaseX = end.x - ux * arrowLength
        let arrowBaseY = end.y - uy * arrowLength
        
        // Draw zigzag all the way to arrow base
        for i in 0...segments {
            let t = CGFloat(i) / CGFloat(segments)
            
            // Calculate points from start to arrow base
            let x1 = start.x + (arrowBaseX - start.x) * t
            let y1 = start.y + (arrowBaseY - start.y) * t
            
            if i % 2 == 0 {
                path.addLine(to: CGPoint(
                    x: x1 + px * 8,
                    y: y1 + py * 8
                ))
            } else {
                path.addLine(to: CGPoint(
                    x: x1 - px * 8,
                    y: y1 - py * 8
                ))
            }
        }
        
        // Draw arrow head as a filled triangle
        let arrowWidth: CGFloat = 15
        
        // Move to arrow base center
        path.move(to: CGPoint(x: arrowBaseX, y: arrowBaseY))
        
        // Draw arrow head outline
        path.addLine(to: CGPoint(
            x: arrowBaseX + px * arrowWidth,
            y: arrowBaseY + py * arrowWidth
        ))
        path.addLine(to: CGPoint(
            x: end.x - ux * 30, // Stop short of the actual end point
            y: end.y - uy * 30
        ))
        path.addLine(to: CGPoint(
            x: arrowBaseX - px * arrowWidth,
            y: arrowBaseY - py * arrowWidth
        ))
        
        // Close the arrow head
        path.closeSubpath()
        
        return path
    }
}
