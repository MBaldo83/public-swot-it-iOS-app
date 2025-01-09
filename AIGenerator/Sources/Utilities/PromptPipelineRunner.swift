import Foundation

protocol PromptInferencer {
    func inference(_ prompt: String)
}

protocol ConfigHandler {
    func write(_ config: PromptConfig)
}

protocol PromptCreator {
    func prompt() -> String
}

struct PipelineStagesRunner: PromptPipelineRunner {
    
    let configHandler: ConfigHandler
    let promptInferencer: PromptInferencer
    
    func inference(
        using promptCreator: PromptCreator,
        with config: PromptConfig
    ) {
        configHandler.write(config)
        
        promptInferencer.inference(
            promptCreator.prompt()
        )
    }
}

struct PromptPipelineRunnerFactory {
    static func aiderProductionPipeline() -> PromptPipelineRunner {
        PipelineStagesRunner(
            configHandler: ConfigYMLWriterComposer(
                fileWriter: AiderConfigYAMLFileWriter(),
                configTemplater: YMLConfigTemplater()
            ),
            promptInferencer: AiderMessagePromptInferencer(
                shellExectuer: ShellExecutor.self
            )
        )
    }
    
    static func dryRunPipeline() -> PromptPipelineRunner {
        PipelineStagesRunner(
            configHandler: ConfigYMLWriterComposer(
                fileWriter: DryRunFileWriter(),
                configTemplater: YMLConfigTemplater()
            ),
            promptInferencer: AiderMessagePromptInferencer(
                shellExectuer: DryRunShellExecutable.self
            )
        )
    }
}
