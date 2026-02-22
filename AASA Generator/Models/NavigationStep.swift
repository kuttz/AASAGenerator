//
//  NavigationStep.swift
//  AASA Generator
//
//  Created by Sreekuttan D on 17/2/26.
//

enum NavigationStep: Int, CaseIterable {
    case configuration = 0
    case pathComponents = 1
    case previewExport = 2
    
    var title: String {
        switch self {
        case .configuration: return "Configuration"
        case .pathComponents: return "Path Components"
        case .previewExport: return "Preview & Export"
        }
    }
}
