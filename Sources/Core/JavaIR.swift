//
//  JavaIR.swift
//  Core
//
//  Created by Rahul Malik on 1/4/18.
//

import Foundation

struct JavaModifier: OptionSet {
    let rawValue: Int
    static let `public` = JavaModifier(rawValue: 1 << 0)
    static let abstract = JavaModifier(rawValue: 1 << 1)
    static let final = JavaModifier(rawValue: 1 << 2)
    static let `static` = JavaModifier(rawValue: 1 << 3)
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

    static func method(annotations: Set<String> = [], _ modifiers: JavaModifier, _ signature: String, body: () -> [String]) -> JavaIR.Method {
        let signatureModifiers = [
            modifiers.contains(.public) ? "public" : "",
            modifiers.contains(.abstract) ? "abstract" : "",
            modifiers.contains(.static) ? "static" : "",
            modifiers.contains(.final) ? "final" : ""
        ].filter { $0 != "" }.joined(separator: " ")
        return JavaIR.Method(annotations: annotations, body: body(), signature: "\(signatureModifiers) \(signature)")
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
