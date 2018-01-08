//
//  JavaFileGenerator
//  plank
//
//  Created by Rahul Malik on 1/4/18.
//

import Foundation

struct JavaGeneratorManager: FileGeneratorManager {

    static func filesToGenerate(descriptor: SchemaObjectRoot, generatorParameters: GenerationParameters) -> [FileGenerator] {
        return [
            JavaFileGenerator(className: descriptor.className(with: generatorParameters))
        ]
    }

    static func runtimeFiles() -> [FileGenerator] {
        return []
    }
}

struct JavaFileGenerator: FileGenerator {

    let className: String

    var fileName: String {
        return "\(className).java"
    }

    func renderFile() -> String {
        // TODO: Update this
        return self.renderCommentHeader()
    }

    var indent: Int {
        return 4
    }
}
