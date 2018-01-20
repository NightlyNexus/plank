//
//  JavaModelRenderer.swift
//  Core
//
//  Created by Rahul Malik on 1/4/18.
//

import Foundation

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

    func renderBuilderProperties(modifiers: JavaModifier = [.public, .abstract]) -> [JavaIR.Method] {
        let props = self.properties.map { param, schemaObj in
            JavaIR.method(modifiers, "Builder set\(param.snakeCaseToCamelCase())(\(self.typeFromSchema(param, schemaObj)) value)") {[]}
        }
        return props
    }

    func renderBuilderInterfaceProperties() -> [JavaIR.Method] {
        return self.renderBuilderProperties(modifiers: [])
    }

    func renderModelProperties(modifiers: JavaModifier = [.public, .abstract]) -> [JavaIR.Method] {
        return self.properties.map { param, schemaObj in
            JavaIR.method(modifiers, "@SerializedName(\"\(param)\") \(self.typeFromSchema(param, schemaObj)) \(param.snakeCaseToPropertyName())()") {[]}
        }
    }

    func renderInterfaceProperties() -> [JavaIR.Method] {
        return self.renderModelProperties(modifiers: [])
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
                "java.net.URI",
                "java.lang.annotation.Retention",
                "java.lang.annotation.RetentionPolicy",
                "android.support.annotation.IntDef",
                "android.support.annotation.Nullable",
                "android.support.annotation.StringDef"
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

        let adtRoots = self.properties.flatMap { (param, prop) -> [JavaIR.Root] in
            switch prop.schema {
            case .oneOf(types: let possibleTypes):
                let objProps = possibleTypes.map { $0.nullableProperty() }
                return adtRootsForSchema(property: param, schemas: objProps)
            case .array(itemType: .some(let itemType)):
                switch itemType {
                case .oneOf(types: let possibleTypes):
                let objProps = possibleTypes.map { $0.nullableProperty() }
                return adtRootsForSchema(property: param, schemas: objProps)
                default: return []
                }
            case .map(valueType: .some(let additionalProperties)):
                switch additionalProperties {
                case .oneOf(types: let possibleTypes):
                    let objProps = possibleTypes.map { $0.nullableProperty() }
                    return adtRootsForSchema(property: param, schemas: objProps)
                default: return []
                }
            default: return []
            }
        }

        let modelInterface = JavaIR.Root.interfaceDecl(aInterface: JavaIR.Interface(
                modifiers: [.public],
                extends: nil,
                name: self.interfaceName(),
                methods: self.renderInterfaceProperties()
            )
        )

        let builderInterface = JavaIR.Root.interfaceDecl(aInterface: JavaIR.Interface(
            modifiers: [.public],
            extends: nil,
            name: self.builderInterfaceName(),
            methods: self.renderBuilderInterfaceProperties()
            )
        )

        let builderClass = JavaIR.Class(
            annotations: ["AutoValue.Builder"],
            modifiers: [.public, .abstract, .static],
            extends: nil,
            implements: self.builderInterfaceName(self.parentDescriptor).map { [$0] },
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
                modifiers: [.public, .abstract],
                extends: nil,
                implements: self.interfaceName(self.parentDescriptor).map { [$0] },
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
            adtRoots +
            [modelInterface, builderInterface, modelClass]
        return roots
    }
}
