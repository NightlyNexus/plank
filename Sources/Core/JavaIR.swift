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

    func render() -> String {
        return [
            self.contains(.public) ? "public" : "",
            self.contains(.abstract) ? "abstract" : "",
            self.contains(.static) ? "static" : "",
            self.contains(.final) ? "final" : ""
        ].filter { $0 != "" }.joined(separator: " ")
    }
}

public struct JavaIR {

    public struct Method {
        let annotations: Set<String>
        let modifiers: JavaModifier
        let body: [String]
        let signature: String

        func render() -> [String] {
            // HACK: We should actually have an enum / optionset that we can check for abstract, static, ...
            let annotationLines = annotations.map { "@\($0)" }

            if modifiers.contains(.abstract) {
                return annotationLines + ["\(modifiers.render()) \(signature);"]
            }
            return annotationLines + [
                "\(modifiers.render()) \(signature) {",
                -->body,
                "}"
            ]
        }
    }

    static func method(annotations: Set<String> = [], _ modifiers: JavaModifier, _ signature: String, body: () -> [String]) -> JavaIR.Method {
        return JavaIR.Method(annotations: annotations, modifiers: modifiers, body: body(), signature: signature)
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
        let modifiers: JavaModifier
        let extends: String?
        let implements: [String]?
        let name: String
        let methods: [JavaIR.Method]
        let enums: [Enum]
        let innerClasses: [JavaIR.Class]

        func render() -> [String] {
            let implementsList = implements?.joined(separator: ", ") ?? ""
            let implementsStmt = implementsList == "" ? "" : "implements \(implementsList)"
            return annotations.map { "@\($0)" } + [
                "\(modifiers.render()) class \(name) \(implementsStmt) {",
                -->enums.flatMap { $0.render() },
                -->methods.flatMap { $0.render() },
                -->innerClasses.flatMap { $0.render() },
                "}"
            ]
        }
    }

    struct Interface {
        let modifiers: JavaModifier
        let extends: String?
        let name: String
        let methods: [JavaIR.Method]

        func render() -> [String] {
            return [
                "\(modifiers.render()) interface \(name) {",
                -->methods.flatMap { "\($0.signature);" },
                "}"
            ]
        }
    }

    enum Root: RootRenderer {
        case packages(names: Set<String>)
        case imports(names: Set<String>)
        case classDecl(aClass: JavaIR.Class)
        case interfaceDecl(aInterface: JavaIR.Interface)

        func renderImplementation() -> [String] {
            switch self {
            case let .packages(names):
                return names.map { "package \($0);" }
            case let .imports(names):
                return names.map { "import \($0);" }
            case let .classDecl(aClass: cls):
                return cls.render()
            case let .interfaceDecl(aInterface: interface):
                return interface.render()
            }
        }
    }
}
