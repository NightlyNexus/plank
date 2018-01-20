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

        let cls = JavaIR.Class(annotations: [],
                     modifiers: [.public, .abstract],
                     extends: nil,
                     implements: nil,
                     name: adtName.snakeCaseToCamelCase(),
                     methods: [],
                     enums: [],
                     innerClasses: [])
        return [

            // Interface
            // Class
            JavaIR.Root.classDecl(aClass: cls)
            // - Properties
            // - Private Constructor
            // - Match method
        ]
    }
}
