//
//  JavaFileGenerator
//  plank
//
//  Created by Rahul Malik on 1/4/18.
//

import Foundation

struct JavaGeneratorManager: FileGeneratorManager {

    static func filesToGenerate(descriptor: SchemaObjectRoot, generatorParameters: GenerationParameters) -> [FileGenerator] {
        return []
    }

    static func runtimeFiles() -> [FileGenerator] {
        return []
    }
}

struct JavaFileGenerator: FileGenerator {

    let className: String

    var fileName: String {
        return "\(className).h"
    }

    func renderFile() -> String {
        return ""
    }

    var indent: Int {
        return 4
    }
}
