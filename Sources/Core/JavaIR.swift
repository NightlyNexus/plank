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
public struct JavaIR {

    public struct Method {
        let body: [String]
        let signature: String

        func render() -> [String] {
            return [
                signature,
                "{",
                -->body,
                "}"
            ]
        }
    }

    static func method(_ signature: String, body: () -> [String]) -> JavaIR.Method {
        return JavaIR.Method(body: body(), signature: signature)
    }

    struct Class {
        let annotations: Set<String>
        let extends: String?
        let name: String
        let innerClasses: [JavaIR.Class]
    }

    enum Root: RootRenderer {

        case packages(names: Set<String>)

        case imports(names: Set<String>)
        case classDecl(
            aClass: JavaIR.Class
        )
        case enumDecl(name: String, values: EnumType)

        func renderImplementation() -> [String] {
            switch self {
            case let .imports(names):
                return names.map { "package \($0);" }
            case let .packages(names):
                return names.map { "import \($0);" }
            case let .classDecl(aClass: cls):
                return cls.annotations.map { "@\($0)" } + [
                    "public abstract class \(cls.name) {",
                    "}"
                ]
            case .enumDecl(_, _):
                // TODO
                break
            }
            return []
        }
    }
}
