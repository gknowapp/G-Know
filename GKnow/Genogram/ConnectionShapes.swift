//
//  ConnectionShapes.swift
//  GKnow
//
//  Created by Curt Leonard on 3/12/25.
//

import Foundation
import SwiftUI

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
        case engaged
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
// MARK: Dating Connection Line
//

struct DatingConnectionLine: Shape {
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
        
        return path//.stroke(style: StrokeStyle(dash: [5,10]))
    }
}

//
// MARK: Affair Connection Line
//
struct AffairConnectionLine: Shape {
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
        
        return path//.stroke(style: StrokeStyle(dash: [5,10]))
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

//
//MARK: Focused Connection Line - A straight line with an arrow at the end
//

struct FocusedConnectionLine : Shape {
    
    let start: CGPoint
    let end: CGPoint
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        // Calculate direction vector
        let dx = end.x - start.x
        let dy = end.y - start.y
        let distance = sqrt(dx * dx + dy * dy)
        
        
        // Calculate unit vector
        let ux = dx / distance
        let uy = dy / distance
        
        let px = -uy
        let py = ux
        
        // Start the path
        path.move(to: start)
        
        let arrowLength: CGFloat = 60 // Increased to ensure visibility
        let arrowBaseX = end.x - ux * arrowLength
        let arrowBaseY = end.y - uy * arrowLength
        
        path.addLine(to: CGPoint(x: arrowBaseX, y: arrowBaseY))
        
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

//
//MARK: Harmony Connection Line - A straight line from one shape to another
//
struct HarmonyConnectionLine : Shape {
    
    let start: CGPoint
    let end: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
    
    
}

//
// MARK: FriendshipConnection - Two parallel lines from one shape to another
//

struct FriendshipConnectionLine: Shape {
    let start: CGPoint
    let end: CGPoint
    let lineSpacing: CGFloat = 10
    
    func path(in rect: CGRect) -> Path {
        // Calculate offsets for the two parallel lines
        let (startLine1, endLine1, startLine2, endLine2) = calculateOffsetPoints()
        
        // Create a combined path
        var path = Path()
        path.addPath(HarmonyConnectionLine(start: startLine1, end: endLine1).path(in: rect))
        path.addPath(HarmonyConnectionLine(start: startLine2, end: endLine2).path(in: rect))
        
        return path
    }
    
    private func calculateOffsetPoints() -> (CGPoint, CGPoint, CGPoint, CGPoint) {
        // Calculate the vector from start to end
        let dx = end.x - start.x
        let dy = end.y - start.y
        
        // Calculate the normalized perpendicular vector
        let length = sqrt(dx * dx + dy * dy)
        guard length > 0 else {
            return (start, end, start, end) // Return same points if length is zero
        }
        
        let perpX = -dy / length
        let perpY = dx / length
        
        // Calculate offset points for the two parallel lines
        let halfSpacing = lineSpacing / 2
        
        let startLine1 = CGPoint(
            x: start.x + perpX * halfSpacing,
            y: start.y + perpY * halfSpacing
        )
        let endLine1 = CGPoint(
            x: end.x + perpX * halfSpacing,
            y: end.y + perpY * halfSpacing
        )
        
        let startLine2 = CGPoint(
            x: start.x - perpX * halfSpacing,
            y: start.y - perpY * halfSpacing
        )
        let endLine2 = CGPoint(
            x: end.x - perpX * halfSpacing,
            y: end.y - perpY * halfSpacing
        )
        
        return (startLine1, endLine1, startLine2, endLine2)
    }
}
//
//MARK: FusionConnectionLine - 3 parallel lines from one point to another
//
struct FusionConnectionLine: Shape {
    let start: CGPoint
    let end: CGPoint
    let lineSpacing: CGFloat = 10
    
    func path(in rect: CGRect) -> Path {
        // Calculate offsets for the three parallel lines
        let (startLine1, endLine1, startLine2, endLine2, startLine3, endLine3) = calculateOffsetPoints()
        
        // Create a combined path
        var path = Path()
        path.addPath(HarmonyConnectionLine(start: startLine1, end: endLine1).path(in: rect))
        path.addPath(HarmonyConnectionLine(start: startLine2, end: endLine2).path(in: rect))
        path.addPath(HarmonyConnectionLine(start: startLine3, end: endLine3).path(in: rect))
        
        return path
    }
    
    private func calculateOffsetPoints() -> (CGPoint, CGPoint, CGPoint, CGPoint, CGPoint, CGPoint) {
        // Calculate the vector from start to end
        let dx = end.x - start.x
        let dy = end.y - start.y
        
        // Calculate the normalized perpendicular vector
        let length = sqrt(dx * dx + dy * dy)
        guard length > 0 else {
            // Return same points if length is zero
            return (start, end, start, end, start, end)
        }
        
        let perpX = -dy / length
        let perpY = dx / length
        
        // Calculate offset points for the three parallel lines
        // Middle line (directly on the path)
        let startLine2 = start
        let endLine2 = end
        
        // Top line
        let startLine1 = CGPoint(
            x: start.x + perpX * lineSpacing,
            y: start.y + perpY * lineSpacing
        )
        let endLine1 = CGPoint(
            x: end.x + perpX * lineSpacing,
            y: end.y + perpY * lineSpacing
        )
        
        // Bottom line
        let startLine3 = CGPoint(
            x: start.x - perpX * lineSpacing,
            y: start.y - perpY * lineSpacing
        )
        let endLine3 = CGPoint(
            x: end.x - perpX * lineSpacing,
            y: end.y - perpY * lineSpacing
        )
        
        return (startLine1, endLine1, startLine2, endLine2, startLine3, endLine3)
    }
}
