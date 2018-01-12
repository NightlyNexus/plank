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
        // We add a convenience setter for Optional types since AutoValue can handle both
        // setFoo(Optional<T> value) and setFoo(T value)
        // https://github.com/google/auto/blob/master/value/userguide/builders-howto.md#-handle-optional-properties
        let convenienceProps = self.properties.filter { _, schemaObj in
            return schemaObj.nullability == nil || schemaObj.nullability == .nullable
        }.map { param, schemaObj in
            JavaIR.method(modifiers, "Builder set\(param.snakeCaseToCamelCase())(\(self.typeFromSchema(param, schemaObj.schema.nonnullProperty())) value)") {[]}
        }
        return props + convenienceProps
    }

    func renderBuilderInterfaceProperties() -> [JavaIR.Method] {
        return self.renderBuilderProperties(modifiers: [])
    }

    func renderModelProperties(modifiers: JavaModifier = [.public, .abstract]) -> [JavaIR.Method] {
        return self.properties.map { param, schemaObj in
            JavaIR.method(modifiers, "\(self.typeFromSchema(param, schemaObj)) \(param.snakeCaseToPropertyName())()") {[]}
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
            [modelInterface, builderInterface, modelClass]
        return roots
    }
}
