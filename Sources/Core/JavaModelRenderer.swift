//
//  JavaModelRenderer.swift
//  Core
//
//  Created by Rahul Malik on 1/4/18.
//

import Foundation

protocol JavaFileRenderer: FileRenderer {}

extension JavaFileRenderer {
    func typeFromSchema(_ param: String, _ schema: SchemaObjectProperty) -> String {
        // TODO: Figure out if "Optional" goes here
        switch schema.schema {
        case .array(itemType: .none):
            return "List<Object>"
        case .array(itemType: .some(let itemType)):
            return "List<\(typeFromSchema(param, itemType.nonnullProperty()))>"
        case .set(itemType: .none):
            return "Set<Object>"
        case .set(itemType: .some(let itemType)):
            return "Set<\(typeFromSchema(param, itemType.nonnullProperty()))>"
        case .map(valueType: .none):
            return "Map<String, Object>"
        case .map(valueType: .some(let valueType)):
            return "Map<String, \(typeFromSchema(param, valueType.nonnullProperty()))>"
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
                return typeFromSchema(param, (.object(schemaRoot) as Schema).nonnullProperty())
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

/*
     @AutoValue
     public abstract class Animal {
     public abstract String name();
     public abstract int numberOfLegs();

     public static Builder builder() {
     return new AutoValue_Animal.Builder();
     }

     abstract Builder toBuilder();

     public Animal withName(String name) {
     return toBuilder().setName(name).build();
     }

     @AutoValue.Builder
     public abstract static class Builder {
     public abstract Builder setName(String value);
     public abstract Builder setNumberOfLegs(int value);
     public abstract Animal build();
     }
     }

 */

    func renderRoots() -> [JavaIR.Root] {
        let roots: [JavaIR.Root] = [
            JavaIR.Root.classDecl(
                aClass: JavaIR.Class(
                    annotations: ["AutoValue"],
                    extends: nil,
                    name: self.className,
                    innerClasses: []
                )
            )
        ]
        return roots
    }
}
