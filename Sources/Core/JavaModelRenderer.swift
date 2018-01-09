//
//  JavaModelRenderer.swift
//  Core
//
//  Created by Rahul Malik on 1/4/18.
//

import Foundation

protocol JavaFileRenderer: FileRenderer {}

extension JavaFileRenderer {
    func typeFromSchema(_ param: String, _ schema: Schema) -> String {
        switch schema {
        case .array(itemType: .none):
            return "List<Object>"
        case .array(itemType: .some(let itemType)):
            return "List<\(typeFromSchema(param, itemType))>"
        case .set(itemType: .none):
            return "Set<Object>"
        case .set(itemType: .some(let itemType)):
            return "Set<\(typeFromSchema(param, itemType))>"
        case .map(valueType: .none):
            return "Map<String, Object>"
        case .map(valueType: .some(let valueType)):
            return "Map<String, \(typeFromSchema(param, valueType))>"
        case .string(format: .none),
             .string(format: .some(.email)),
             .string(format: .some(.hostname)),
             .string(format: .some(.ipv4)),
             .string(format: .some(.ipv6)):
            return "String"
        case .string(format: .some(.dateTime)):
            return "Date"
        case .string(format: .some(.uri)):
            return "URI"
        case .integer:
            return "Integer"
        case .float:
            return "Double"
        case .boolean:
            return "Boolean"
        case .enumT:
            return enumTypeName(propertyName: param, className: className)
        case .object(let objSchemaRoot):
            return "\(objSchemaRoot.className(with: params))"
        case .reference(with: let ref):
            switch ref.force() {
            case .some(.object(let schemaRoot)):
                return typeFromSchema(param, .object(schemaRoot))
            default:
                fatalError("Bad reference found in schema for class: \(className)")
            }
        case .oneOf(types:_):
            return "\(className)\(param.snakeCaseToCamelCase())"
        }
    }
}

public struct JavaModelRenderer: JavaFileRenderer {
    let rootSchema: SchemaObjectRoot
    let params: GenerationParameters

    init(rootSchema: SchemaObjectRoot, params: GenerationParameters) {
        self.rootSchema = rootSchema
        self.params = params
    }

    func renderRoots() -> [JavaIR.JavaRoot] {
        return []
    }
}
