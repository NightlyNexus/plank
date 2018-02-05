//
//  JavaADTRenderer.swift
//  Core
//
//  Created by Rahul Malik on 1/19/18.
//

import Foundation

extension JavaModelRenderer {
    /*
     interface FooADTVisitor<R> {
         R match(Pin);
         R match(Board);
     }
     public abstract class FooADT<R> {
     [properties here]
     private FooADT() {}
     public abstract R match Foo(FooADTVisitor<R>);

     }
     */
    func adtRootsForSchema(property: String, schemas: [SchemaObjectProperty]) -> [JavaIR.Root] {

        // Open Q: How should AutoValue/GSON work with this?
        // Do we need to create a custom runtime type adapter factory?
        let adtName = "\(self.rootSchema.name)_\(property)"
        let formattedADTName = adtName.snakeCaseToCamelCase()
        let privateInit = JavaIR.method([.private], "\(formattedADTName)()") {[]}

        func interfaceMethods() -> [JavaIR.Method] {
            return schemas
                .map { typeFromSchema("", $0) }
                .map { JavaIR.method([], "R match(\($0))") {[]} }
        }

        let matcherInterface = JavaIR.Interface(modifiers: [],
                         extends: nil,
                         name: "\(formattedADTName)Matcher<R>",
            methods: interfaceMethods())

        let matcherMethod = JavaIR.method([.public], "R match \(formattedADTName)(\(formattedADTName)Matcher<R>)") {[]}

        let cls = JavaIR.Class(annotations: [],
                     modifiers: [.public, .final],
                     extends: nil,
                     implements: nil,
                     name: "\(formattedADTName)<R>",
                     methods: [
                        privateInit,
                        matcherMethod
                     ],
                     enums: [],
                     innerClasses: [])
        return [
            // Interface
            JavaIR.Root.interfaceDecl(aInterface: matcherInterface),
            // Class
            JavaIR.Root.classDecl(aClass: cls)
            // - Properties
            // - Private Constructor
            // - Match method

        ]
    }
}
