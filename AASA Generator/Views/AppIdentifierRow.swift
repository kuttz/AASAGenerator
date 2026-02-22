//
//  AppIdentifierRow.swift
//  AASA Generator
//
//  Created by Sreekuttan D on 17/2/26.
//

import SwiftUI

struct AppIdentifierRow: View {
    let appIdentifier: AppIdentifier
    let canRemove: Bool
    let onUpdate: ((inout AppIdentifier) -> Void) -> Void
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Team ID")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("e.g., 9JA89QQLNQ", text: Binding(
                            get: { appIdentifier.teamID },
                            set: { newValue in onUpdate { $0.teamID = newValue.uppercased() } }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .font(.system(.body, design: .monospaced))
                        .textCase(.uppercase)
                        .disableAutocorrection(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Bundle Identifier")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("e.g., com.example.app", text: Binding(
                            get: { appIdentifier.bundleID },
                            set: { newValue in onUpdate { $0.bundleID = newValue } }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .font(.system(.body, design: .monospaced))
                    }
                    
                    if !appIdentifier.teamID.isEmpty && !appIdentifier.bundleID.isEmpty {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.caption)
                            Text("App ID: \(appIdentifier.appID)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                if canRemove {
                    Button(action: onRemove) {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}
