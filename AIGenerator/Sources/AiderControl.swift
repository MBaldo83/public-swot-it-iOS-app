import Foundation

protocol PromptPipelineRunner {
    func inference(
        using promptCreator: PromptCreator,
        with config: PromptConfig
    )
}

struct AiderControl {
    
    var promptPipelineRunner: PromptPipelineRunner = PromptPipelineRunnerFactory.dryRunPipeline()
    
    /**
     Control your generation by editing the commands below.
     */
    func run() {
        
        
/** Generation History **/
//        generateMocksForDomainDataModels()
//        generateViewHandlerUnitTests()
//        generateDeckResultsNavigation()
    }
}
