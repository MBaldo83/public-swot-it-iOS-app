import Foundation

struct DomainDataModelMockingSpec {
    let dataModelToMock: String         //
    let dataModelFolderPath: String     //
    let exampleMock: String             // Eg. LocalDeck
    let exampleMockFolderPath: String   // Eg. Swot_It/SwotItTests/Domain/DomainDataStructures
}

struct DomainDataModelMockPromptCreator {
    let domainDataModel: DomainDataModelMockingSpec
}

extension DomainDataModelMockPromptCreator: PromptCreator {
    func prompt() -> String {
        return """
If \(domainDataModel.dataModelToMock) is NOT a struct, then return immediately and do not generate any new code. \
If a mock function for \(domainDataModel.dataModelToMock) already exists, then return immediately and do not generate any new code. \
Write a static function 'mock' as an extension of \(domainDataModel.dataModelToMock) in \(domainDataModel.mockFilePath). \
Follow the example of \(domainDataModel.exampleMock) mock function in \(domainDataModel.exampleMockFileName). \
Every property of the entity should be given a default value in the arguments to the mock function
"""
    }
}

extension DomainDataModelMockingSpec {
    var mockFileFolderPath: String {
        dataModelFolderPath.replacingOccurrences(of: "Swot_It/SwotItApp/", with: "Swot_It/SwotItTests/")
    }
    
    var mockFileName: String {
        "\(dataModelToMock)Mock.swift"
    }
    
    var mockFilePath: String {
        "\(mockFileFolderPath)/\(mockFileName)"
    }
    
    var exampleMockFileName: String {
        "\(exampleMock)Mock.swift"
    }
    
    var exampleMockFilePath: String {
        "\(exampleMockFolderPath)/\(exampleMockFileName)"
    }
}

extension DomainDataModelMockingSpec: PromptConfig {
    var filesToAdd: [String] {
        [
            "\(dataModelFolderPath)/\(dataModelToMock).swift",
            mockFilePath,
            exampleMockFilePath
        ]
    }
}
