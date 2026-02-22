//
//  ConfigurationView.swift
//  AASA Generator
//
//  Created by Sreekuttan D on 17/2/26.
//

import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var viewModel: AASAViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.blue)
                    Text("AASA File Generator")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Generate Apple App Site Association Files")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 20)
                
                // App Identifiers Configuration
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("App Identifiers")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: viewModel.addAppIdentifier) {
                            Label("Add App", systemImage: "plus.circle.fill")
                                .font(.subheadline)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Text("Add one or more apps that should handle universal links")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 16) {
                        ForEach(Array(viewModel.appIdentifiers.enumerated()), id: \.element.id) { index, appID in
                            AppIdentifierRow(
                                appIdentifier: appID,
                                canRemove: viewModel.appIdentifiers.count > 1,
                                onUpdate: { update in
                                    viewModel.updateAppIdentifier(at: index, update)
                                },
                                onRemove: {
                                    viewModel.removeAppIdentifier(at: index)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Divider()
                    .padding(.horizontal, 40)
                
                // Additional Features
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Additional Features")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    VStack(spacing: 16) {
                        // Web Credentials Group
                        VStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Web Credentials")
                                        .font(.body)
                                    Text("Allow password autofill from this domain")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Toggle("", isOn: $viewModel.enableWebCredentials)
                                    .toggleStyle(.switch)
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                        }
                        
                        // App Clips Group
                        VStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("App Clips")
                                        .font(.body)
                                    Text("Enable App Clips support")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Toggle("", isOn: $viewModel.enableAppClips)
                                    .toggleStyle(.switch)
                                    .labelsHidden()
                            }
                            .padding()
                            
                            if viewModel.enableAppClips {
                                Divider()
                                    .padding(.leading)
                                    .padding(.trailing)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Generated App Clip IDs")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    if !viewModel.appIdentifiers.filter({ !$0.bundleID.isEmpty }).isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            ForEach(viewModel.appIdentifiers.filter { !$0.bundleID.isEmpty }, id: \.id) { appID in
                                                HStack(spacing: 8) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .font(.caption)
                                                        .foregroundStyle(.green)
                                                    Text("\(appID.bundleID).Clip")
                                                        .font(.system(.caption, design: .monospaced))
                                                        .foregroundStyle(.primary)
                                                    Spacer()
                                                }
                                            }
                                        }
                                    } else {
                                        HStack {
                                            Text("Add bundle identifiers in Configuration to see App Clip IDs")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                                .italic()
                                            Spacer()
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
    }
}
