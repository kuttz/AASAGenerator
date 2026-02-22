//
//  PathComponentsView.swift
//  AASA Generator
//
//  Created by Sreekuttan D on 17/2/26.
//

import SwiftUI

struct PathComponentsView: View {
    @ObservedObject var viewModel: AASAViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.blue)
                Text("Path Components")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Define which URLs should open in your app")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // Add Component Button
            HStack {
                Spacer()
                Button(action: viewModel.addComponent) {
                    Label("Add Component", systemImage: "plus.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                .padding(.trailing, 40)
            }
            .padding(.bottom, 12)
            
            // Components List
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.components.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "link.badge.plus")
                                .font(.system(size: 50))
                                .foregroundStyle(.secondary)
                            Text("No components yet")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                            Text("Add a component to define URL patterns")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        ForEach(Array(viewModel.components.enumerated()), id: \.element.id) { index, component in
                            ComponentRow(
                                component: component,
                                onUpdate: { update in
                                    viewModel.updateComponent(at: index, update)
                                },
                                onRemove: {
                                    viewModel.removeComponent(at: index)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
    }
}
