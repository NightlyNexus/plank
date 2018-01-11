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
        switch schema.nullability {
        case .some(.nonnull):
            return unwrappedTypeFromSchema(param, schema.schema)
        case .some(.nullable), .none:
            return "Optional<\(unwrappedTypeFromSchema(param, schema.schema))>"
        }
    }
    fileprivate func unwrappedTypeFromSchema(_ param: String, _ schema: Schema) -> String {
        // TODO: Figure out if "Optional" goes here
        switch schema {
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
        case .enumT(let enumObj):
            let enumName = enumTypeName(propertyName: param, className: className)
            switch enumObj {
            case .integer(_):
                return "@\(enumName) int"
            case .string(_, defaultValue: _):
                return "@\(enumName) String"
            }
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

    func renderBuilder() -> JavaIR.Method {
        return JavaIR.method([.public, .static], "Builder builder()") {[
            "return new AutoValue_\(className).Builder();"
        ]}
    }

    func renderBuilderBuild() -> JavaIR.Method {
        return JavaIR.method([.public, .abstract], "\(self.className) build()") {[]}
    }

    func renderToBuilder() -> JavaIR.Method {
        return JavaIR.method([.abstract], "Builder toBuilder()") {[]}
    }

    func renderBuilderProperties() -> [JavaIR.Method] {
        let props = self.properties.map { param, schemaObj in
            JavaIR.method([.public, .abstract], "Builder set\(param.snakeCaseToCamelCase())(\(self.typeFromSchema(param, schemaObj)) value)") {[]}
        }
        // We add a convenience setter for Optional types since AutoValue can handle both
        // setFoo(Optional<T> value) and setFoo(T value)
        // https://github.com/google/auto/blob/master/value/userguide/builders-howto.md#-handle-optional-properties
        let convenienceProps = self.properties.filter { _, schemaObj in
            return schemaObj.nullability == nil || schemaObj.nullability == .nullable
        }.map { param, schemaObj in
            JavaIR.method([.public, .abstract], "Builder set\(param.snakeCaseToCamelCase())(\(self.typeFromSchema(param, schemaObj.schema.nonnullProperty())) value)") {[]}
        }
        return props + convenienceProps
    }

    func renderModelProperties() -> [JavaIR.Method] {
        return self.properties.map { param, schemaObj in
            JavaIR.method([.public, .abstract], "\(self.typeFromSchema(param, schemaObj)) \(param.snakeCaseToPropertyName())()") {[]}
        }
    }

    func renderRoots() -> [JavaIR.Root] {
        let packages = self.params[.packageName].flatMap {
            [JavaIR.Root.packages(names: [$0])]
        } ?? []

        let imports = [
            JavaIR.Root.imports(names: [
                "com.google.auto.value.AutoValue",
                "java.util.Date",
                "java.util.Map",
                "java.util.Set",
                "java.util.List",
                "java.util.Optional",
                "java.net.URI",
                "java.lang.annotation.Retention",
                "java.lang.annotation.RetentionPolicy",
                "android.support.annotation.StringDef",
                "android.support.annotation.IntDef"
            ])
        ]

        let enumProps = self.properties.flatMap { (param, prop) -> [JavaIR.Enum] in
            switch prop.schema {
            case .enumT(let enumValues):
                return [
                    JavaIR.Enum(
                        name: enumTypeName(propertyName: param, className: self.className),
                        values: enumValues
                    )
                ]
            default: return []
            }
        }

        let builderClass = JavaIR.Class(
            annotations: ["AutoValue.Builder"],
            extends: nil,
            name: "Builder",
            methods: self.renderBuilderProperties() + [
                self.renderBuilderBuild()
            ],
            enums: [],
            innerClasses: []
        )

        let modelClass = JavaIR.Root.classDecl(
            aClass: JavaIR.Class(
                annotations: ["AutoValue"],
                extends: nil,
                name: self.className,
                methods: self.renderModelProperties() + [
                    self.renderBuilder(),
                    self.renderToBuilder()
                ],
                enums: enumProps,
                innerClasses: [
                    builderClass
                ]
            )
        )

        let roots: [JavaIR.Root] =
            packages +
            imports +
            [modelClass]
        return roots
    }
}
