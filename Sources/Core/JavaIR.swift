//
//  JavaIR.swift
//  Core
//
//  Created by Rahul Malik on 1/4/18.
//

import Foundation

public enum JavaVisibility: String {
    case `public`
    case protected
    case `private`
}

public struct JavaIR {
    enum JavaRoot: RootRenderer {
        case imports(packageNames: Set<String>)
        case classDecl(
            annotations: Set<String>,
            extends: String?,
            name: String
        )
        case enumDecl(name: String, values: EnumType)
        func renderImplementation() -> [String] {
            return []
        }
    }
}
