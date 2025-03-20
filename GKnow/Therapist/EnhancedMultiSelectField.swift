//
//  EnhancedMultiSelectField.swift
//  GKnow
//
//  Created by Curt Leonard on 3/20/25.
//
import SwiftUI

// Enhanced multi-select field
struct EnhancedMultiSelectField: View {
    let label: String
    let options: [String]
    @Binding var selections: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(label)
                .font(.headline)
                .foregroundColor(Color("Dark Green"))
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        toggleSelection(option)
                    }) {
                        HStack {
                            Image(systemName: selections.contains(option) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selections.contains(option) ? Color("Dark Green") : Color.gray.opacity(0.5))
                            
                            Text(option)
                                .foregroundColor(Color("Dark Green"))
                            
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selections.contains(option) ? Color("Dark Green") : Color.gray.opacity(0.3), lineWidth: 1)
                                .background(
                                    selections.contains(option) ?
                                        Color("Light Green").opacity(0.2) :
                                        Color.white
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private func toggleSelection(_ option: String) {
        if selections.contains(option) {
            selections.remove(option)
        } else {
            selections.insert(option)
        }
    }
}
