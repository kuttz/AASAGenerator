//
//  AASAViewModel.swift
//  AASA Generator
//
//  Created by Sreekuttan D on 17/2/26.
//

import Foundation
import SwiftUI
import Combine

struct AppIdentifier: Identifiable, Equatable {
    let id = UUID()
    var teamID: String
    var bundleID: String
    
    var appID: String {
        return "\(teamID).\(bundleID)"
    }
}

struct PathComponent: Identifiable, Equatable {
    let id = UUID()
    var path: String
    var exclude: Bool
    var comment: String
    var fragmentPattern: String // For # pattern
    var queryParameters: [String: String] // For ? pattern
    
    init(path: String = "/", exclude: Bool = false, comment: String = "", fragmentPattern: String = "", queryParameters: [String: String] = [:]) {
        self.path = path
        self.exclude = exclude
        self.comment = comment
        self.fragmentPattern = fragmentPattern
        self.queryParameters = queryParameters
    }
}

class AASAViewModel: ObservableObject {
    @Published var appIdentifiers: [AppIdentifier] = [AppIdentifier(teamID: "", bundleID: "")]
    @Published var components: [PathComponent] = []
    @Published var enableWebCredentials: Bool = false
    @Published var enableAppClips: Bool = false
    @Published var generatedJSON: String = ""
    @Published var isGenerated: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var savedFileURL: URL?
    
    
    func generateAASA() {
        // Build components array
        var componentsArray: [[String: Any]] = []
        
        // If no components provided, use default "/*" to match all paths
        if components.isEmpty {
            componentsArray.append(["/": "/*"])
        } else {
            for component in components {
                var componentDict: [String: Any] = [:]
                
                // Add path
                if !component.path.isEmpty {
                    componentDict["/"] = component.path
                }
                
                // Add fragment pattern if present
                if !component.fragmentPattern.isEmpty {
                    componentDict["#"] = component.fragmentPattern
                }
                
                // Add query parameters if present
                if !component.queryParameters.isEmpty {
                    componentDict["?"] = component.queryParameters
                }
                
                // Add comment if present
                if !component.comment.isEmpty {
                    componentDict["comment"] = component.comment
                }
                
                // Add exclude flag - always include it for clarity
                if component.exclude {
                    componentDict["exclude"] = true
                }
                
                componentsArray.append(componentDict)
            }
        }
        
        // Build appIDs array from all valid app identifiers
        let appIDs = appIdentifiers
            .filter { !$0.teamID.isEmpty && !$0.bundleID.isEmpty }
            .map { $0.appID }
        
        guard !appIDs.isEmpty else {
            alertMessage = "Please add at least one valid app identifier (Team ID + Bundle ID)"
            showAlert = true
            return
        }
        
        // Build applinks section
        var aasaContent: [String: Any] = [
            "applinks": [
                "details": [
                    [
                        "appIDs": appIDs,
                        "components": componentsArray
                    ]
                ]
            ]
        ]
        
        // Add webcredentials if enabled
        if enableWebCredentials {
            aasaContent["webcredentials"] = [
                "apps": appIDs
            ]
        }
        
        // Add appclips if enabled
        if enableAppClips {
            // Generate app clip IDs from existing bundle IDs by appending .Clip
            let clipIDs = appIdentifiers
                .filter { !$0.teamID.isEmpty && !$0.bundleID.isEmpty }
                .map { "\($0.teamID).\($0.bundleID).Clip" }
            
            if !clipIDs.isEmpty {
                aasaContent["appclips"] = [
                    "apps": clipIDs
                ]
            }
        }
        
        do {
            var options: JSONSerialization.WritingOptions = [.prettyPrinted, .sortedKeys]
            if #available(macOS 10.15, *) {
                options.insert(.withoutEscapingSlashes)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: aasaContent, options: options)
            generatedJSON = String(data: jsonData, encoding: .utf8) ?? ""
            isGenerated = true
        } catch {
            alertMessage = "Error generating AASA file: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func downloadAASA() {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "apple-app-site-association"
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = true
        savePanel.message = "Choose where to save the AASA file"
        savePanel.prompt = "Save"
        
        // Allow saving without extension
        if #available(macOS 11.0, *) {
            savePanel.allowedContentTypes = []
        }
        
        savePanel.begin { [weak self] response in
            guard let self = self else { return }
            
            if response == .OK, let url = savePanel.url {
                do {
                    // Ensure we save without extension
                    var finalURL = url
                    if !finalURL.pathExtension.isEmpty {
                        finalURL = finalURL.deletingPathExtension()
                    }
                    
                    try self.generatedJSON.write(to: finalURL, atomically: true, encoding: .utf8)
                    
                    DispatchQueue.main.async {
                        self.savedFileURL = finalURL
                        self.alertMessage = "AASA file saved successfully to:\n\(finalURL.path)"
                        self.showAlert = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.savedFileURL = nil
                        self.alertMessage = "Error saving file: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
    
    func showInFinder() {
        guard let url = savedFileURL else { return }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
    func addAppIdentifier() {
        appIdentifiers.append(AppIdentifier(teamID: "", bundleID: ""))
    }
    
    func removeAppIdentifier(at index: Int) {
        guard index < appIdentifiers.count, appIdentifiers.count > 1 else { return }
        appIdentifiers.remove(at: index)
    }
    
    func updateAppIdentifier(at index: Int, _ update: (inout AppIdentifier) -> Void) {
        guard index < appIdentifiers.count else { return }
        update(&appIdentifiers[index])
    }
    
    func addComponent() {
        components.append(PathComponent())
    }
    
    func removeComponent(at index: Int) {
        guard index < components.count else { return }
        components.remove(at: index)
    }
    
    func updateComponent(at index: Int, _ update: (inout PathComponent) -> Void) {
        guard index < components.count else { return }
        update(&components[index])
    }
    
    func clearGenerated() {
        generatedJSON = ""
        isGenerated = false
        savedFileURL = nil
    }
}
