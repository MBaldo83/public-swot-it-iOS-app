import Foundation

extension AiderControl {
    
    func generateMocksForDomainDataModels() {
        
        DirectoryFileMapper(
            relativePath: "Swot_It/SwotItApp/Domain/DomainDataStructures"
        ).mapFiles { fileName, directoryName in
            
            let spec = DomainDataModelMockingSpec(
                dataModelToMock: fileName.replacingOccurrences(of: ".swift", with: ""),
                dataModelFolderPath: directoryName,
                exampleMock: "LocalDeck",
                exampleMockFolderPath: "Swot_It/SwotItTests/Domain/DomainDataStructures"
            )
            let config = spec
            
            self.promptPipelineRunner.inference(
                using: DomainDataModelMockPromptCreator(
                    domainDataModel: spec
                ),
                with: config
            )
        }
    }
}
