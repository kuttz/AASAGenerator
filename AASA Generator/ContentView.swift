//
//  ContentView.swift
//  AASA Generator
//
//  Created by Sreekuttan D on 17/2/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AASAViewModel()
    @State private var currentStep: NavigationStep = .configuration
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            HStack(spacing: 0) {
                ForEach(NavigationStep.allCases, id: \.self) { step in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(currentStep.rawValue >= step.rawValue ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 10, height: 10)
                        Text(step.title)
                            .font(.caption)
                            .foregroundStyle(currentStep.rawValue >= step.rawValue ? .primary : .secondary)
                        
                        if step != NavigationStep.allCases.last {
                            Rectangle()
                                .fill(currentStep.rawValue > step.rawValue ? Color.blue : Color.gray.opacity(0.3))
                                .frame(height: 2)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Content
            ZStack {
                if currentStep == .configuration {
                    ConfigurationView(viewModel: viewModel)
                } else if currentStep == .pathComponents {
                    PathComponentsView(viewModel: viewModel)
                } else {
                    PreviewExportView(viewModel: viewModel)
                }
            }
            
            Divider()
            
            // Navigation Buttons
            HStack {
                if currentStep != .configuration {
                    Button(action: goBack) {
                        Label("Back", systemImage: "chevron.left")
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("[", modifiers: .command)
                }
                
                Spacer()
                
                if currentStep == .previewExport {
                    Button(action: goToStart) {
                        Label("Done", systemImage: "checkmark.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
                } else {
                    Button(action: goNext) {
                        Label("Next", systemImage: "chevron.right")
                            .labelStyle(.titleAndIcon)
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut("]", modifiers: .command)
                    .disabled(!canProceed)
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(minWidth: 700, minHeight: 650)
        .alert("AASA Generator", isPresented: $viewModel.showAlert) {
            if viewModel.savedFileURL != nil {
                Button("Show in Finder") {
                    viewModel.showInFinder()
                }
                Button("OK", role: .cancel) { }
            } else {
                Button("OK", role: .cancel) { }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case .configuration:
            // At least one app identifier must be complete
            return viewModel.appIdentifiers.contains { !$0.teamID.isEmpty && !$0.bundleID.isEmpty }
        case .pathComponents:
            // Components can be empty (will use default "/*")
            return true
        case .previewExport:
            return true
        }
    }
    
    private func goNext() {
        if let nextStep = NavigationStep(rawValue: currentStep.rawValue + 1) {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentStep = nextStep
            }
        }
    }
    
    private func goBack() {
        if let previousStep = NavigationStep(rawValue: currentStep.rawValue - 1) {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentStep = previousStep
            }
        }
    }
    
    private func goToStart() {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentStep = .configuration
        }
    }
}

#Preview {
    ContentView()
}
