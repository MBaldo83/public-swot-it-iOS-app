import Foundation

protocol ShellExecutable {
    static func shellContinuousPrint(_ command: String)
    static func shell(_ command: String) -> String
}

struct AiderMessagePromptInferencer: PromptInferencer {
    
    let shellExectuer: ShellExecutable.Type
    func inference(_ prompt: String) {
        shellExectuer.shellContinuousPrint("""
aider --message "\(prompt)"
""")
    }
}
