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

    public struct Method {
        let annotations: Set<String>
        let body: [String]
        let signature: String

        func render() -> [String] {
            // HACK: We should actually have an enum / optionset that we can check for abstract, static, ...
            let annotationLines = annotations.map { "@\($0)" }
            if signature.contains("abstract") {
                return annotationLines + ["\(signature);"]
            }
            return annotationLines + [
                "\(signature) {",
                -->body,
                "}"
            ]
        }
    }

    static func method(annotations: Set<String> = [], _ signature: String, body: () -> [String]) -> JavaIR.Method {
        return JavaIR.Method(annotations: annotations, body: body(), signature: signature)
    }

    struct Enum {
        let name: String
        let values: EnumType

        func render() -> [String] {
            switch values {
            case let .integer(values):
                let names = values
                    .map { ($0.description.uppercased(), $0.defaultValue) }
                    .map { "public static final int \($0.0) = \($0.1);" }
                let defAnnotationNames = values
                    .map { $0.description.uppercased() }
                    .joined(separator: ", ")
                return names + [
                    "@IntDef({\(defAnnotationNames)})",
                    "@Retention(RetentionPolicy.SOURCE)",
                    "public @interface \(name) {}"
                ]
            case let .string(values, defaultValue: _):
                // TODO: Use default value in builder method to specify what our default value should be
                let names = values
                    .map { ($0.description.uppercased(), $0.defaultValue) }
                    .map { "public static final String \($0.0) = \"\($0.1)\";" }
                let defAnnotationNames = values
                    .map { $0.description.uppercased() }
                    .joined(separator: ", ")
                return names + [
                    "@StringDef({\(defAnnotationNames)})",
                    "@Retention(RetentionPolicy.SOURCE)",
                    "public @interface \(name) {}"
                ]
            }
        }
    }

    struct Class {
        let annotations: Set<String>
        let extends: String?
        let name: String
        let methods: [JavaIR.Method]
        let enums: [Enum]
        let innerClasses: [JavaIR.Class]

        func render() -> [String] {
            return annotations.map { "@\($0)" } + [
                "public abstract class \(name) {",
                -->enums.flatMap { $0.render() },
                -->methods.flatMap { $0.render() },
                -->innerClasses.flatMap { $0.render() },
                "}"
            ]
        }
    }

    enum Root: RootRenderer {
        case packages(names: Set<String>)
        case imports(names: Set<String>)
        case classDecl(
            aClass: JavaIR.Class
        )

        func renderImplementation() -> [String] {
            switch self {
            case let .packages(names):
                return names.map { "package \($0);" }
            case let .imports(names):
                return names.map { "import \($0);" }
            case let .classDecl(aClass: cls):
                return cls.render()
            }
        }
    }
}
