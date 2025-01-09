import Foundation

extension AiderControl {
    
    func generateViewHandlerUnitTests() {
        
        DirectoryFileMapper(
            relativePath: "Swot_It/SwotItApp/ViewHandlers"
        )
        .mapFiles { fileName, directoryName in
            guard fileName.hasSuffix(".swift") else { return }
            let entityName = String(fileName.dropLast(6)) // Remove the ".swift" suffix
            
            let spec = UnitTestSpec(
                sut: .init(
                    entityName: entityName,
                    relativeFolderPath: directoryName
                ),
                mockFilePath: "Swot_It/SwotItTests/ViewHandlers/ViewHandlerMocks.swift"
            )
            let creator = UnitTestPromptCreator(
                unitTestFeature: spec
            )
            
            promptPipelineRunner.inference(
                using: creator,
                with: spec
            )
        }
    }
}
