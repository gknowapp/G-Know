//
//  GKnowModels.swift
//  GKnow
//
//  Created by Curt Leonard on 5/1/25.
//
import Foundation
import CoreData
import PencilKit
import SwiftUI

// Import CoreData generated classes
@objc(Patient)
public class Patient: NSManagedObject { }

@objc(Genogram)
public class Genogram: NSManagedObject { }

@objc(GenogramShape)
public class GenogramShape: NSManagedObject, ObservableObject { }

@objc(Connection)
public class Connection: NSManagedObject { }

@objc(Drawing)
public class Drawing: NSManagedObject { }

// Extensions for Identifiable
extension Patient: Identifiable { }
extension Genogram: Identifiable { }
extension GenogramShape: Identifiable { }
extension Connection: Identifiable { }
extension Drawing: Identifiable { }

// Custom type for Connection
enum ConnectionType: String {
    case marriage
    case harmony
    case friendship
    case divorce
    case fusion
    case abuse
    case focus
    case dating
    case affair
    case child
    case conflict
}

// Helper Views
struct MarriageConnectionLine: Shape {
    let start: CGPoint
    let end: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct ChildConnectionLine: Shape {
    let startPoint: CGPoint
    let childPoint: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: startPoint)
        path.addLine(to: childPoint)
        return path
    }
}

// Platform-specific view representable for PencilKit
#if os(iOS)
struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var drawing: PKDrawing
    @Binding var isDrawing: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        canvasView.drawing = drawing
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if !isDrawing {
            DispatchQueue.main.async {
                drawing = uiView.drawing
            }
        }
    }
}
#else
struct CanvasView: View {
    @Binding var canvasView: PKCanvasView
    @Binding var drawing: PKDrawing
    @Binding var isDrawing: Bool
    
    var body: some View {
        Text("PencilKit not available on this platform")
    }
}
#endif

// Side Panel View
struct SidePanelView: View {
    let iconName: String
    let description: String
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text(description)
                .padding()
            
            Spacer()
        }
    }
}
