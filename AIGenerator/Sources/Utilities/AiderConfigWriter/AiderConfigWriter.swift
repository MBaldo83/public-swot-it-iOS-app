import Foundation

protocol ConfigTemplater {
    func string(from: PromptConfig) -> String
}

protocol FileWriter {
    func write(_ string: String)
}

struct ConfigYMLWriterComposer: ConfigHandler {
    
    let fileWriter: FileWriter
    let configTemplater: ConfigTemplater
    
    func write(_ config: any PromptConfig) {
        fileWriter.write(
            configTemplater.string(
                from: config
            )
        )
    }
}
