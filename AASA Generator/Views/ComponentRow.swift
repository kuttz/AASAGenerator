//
//  ComponentRow.swift
//  AASA Generator
//
//  Created by Sreekuttan D on 17/2/26.
//

import SwiftUI

struct ComponentRow: View {
    let component: PathComponent
    let onUpdate: ((inout PathComponent) -> Void) -> Void
    let onRemove: () -> Void
    
    @State private var showAdvanced: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    // Path
                    TextField("Path (e.g., /buy/*)", text: Binding(
                        get: { component.path },
                        set: { newValue in onUpdate { $0.path = newValue } }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
                    
                    // Comment
                    TextField("Comment (optional)", text: Binding(
                        get: { component.comment },
                        set: { newValue in onUpdate { $0.comment = newValue } }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .font(.caption)
                    
                    // Exclude toggle
                    Toggle("Exclude (prevent opening as universal link)", isOn: Binding(
                        get: { component.exclude },
                        set: { newValue in onUpdate { $0.exclude = newValue } }
                    ))
                    .toggleStyle(.switch)
                    .font(.caption)
                    
                    // Advanced options toggle
                    Button(action: { showAdvanced.toggle() }) {
                        Label(showAdvanced ? "Hide Advanced" : "Show Advanced (# and ?)",
                              systemImage: showAdvanced ? "chevron.up" : "chevron.down")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    
                    if showAdvanced {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Fragment Pattern (#)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            TextField("e.g., no_universal_links", text: Binding(
                                get: { component.fragmentPattern },
                                set: { newValue in onUpdate { $0.fragmentPattern = newValue } }
                            ))
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.caption, design: .monospaced))
                            
                            Text("Query Parameters (?) - Not editable in this version")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.leading, 8)
                    }
                }
                
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}
