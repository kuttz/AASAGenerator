//
//  PreviewExportView.swift
//  AASA Generator
//
//  Created by Sreekuttan D on 17/2/26.
//

import SwiftUI

struct PreviewExportView: View {
    @ObservedObject var viewModel: AASAViewModel
    
    private var hasValidAppIdentifiers: Bool {
        viewModel.appIdentifiers.contains { !$0.teamID.isEmpty && !$0.bundleID.isEmpty }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 40))
                    .foregroundStyle(.blue)
                Text("Preview & Export")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Review and download your AASA file")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
            
            // Action Buttons
            HStack(spacing: 16) {
                Button(action: viewModel.generateAASA) {
                    Label("Generate AASA", systemImage: "hammer.fill")
                        .frame(width: 160)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!hasValidAppIdentifiers)
                
                Button(action: viewModel.downloadAASA) {
                    Label("Download", systemImage: "arrow.down.doc.fill")
                        .frame(width: 160)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .disabled(!viewModel.isGenerated)
            }
            
            // Preview Section
            if viewModel.isGenerated {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Generated apple-app-site-association file:")
                        .font(.headline)
                    
                    ScrollView {
                        Text(viewModel.generatedJSON)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(NSColor.textBackgroundColor))
                            .cornerRadius(8)
                            .textSelection(.enabled)
                    }
                }
                .padding(.horizontal, 40)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.fill.badge.ellipsis")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                    Text("No preview available")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Text("Click 'Generate AASA' to create your file")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
        }
        .onDisappear {
            viewModel.clearGenerated()
        }
    }
}
