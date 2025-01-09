import Foundation

struct SwiftEntity {
    let entityName: String // EG "Router"
    let relativeFolderPath: String // EG "Swot_It/SwotItApp/Navigation"
}

struct UnitTestSpec {
    let sut: SwiftEntity
    let mockFilePath: String // EG "Swot_It/SwotItTests/Navigation/NavigationMocks.swift"
}

extension SwiftEntity {
    
    var testRelativeFolderPath: String {
        relativeFolderPath.replacingOccurrences(of: "Swot_It/SwotItApp/", with: "Swot_It/SwotItTests/")
    }
    
    var testEntityName: String {
        "\(entityName)Tests"
    }
}

extension UnitTestSpec: PromptConfig {
    var filesToAdd: [String] {
        [
            "\(sut.relativeFolderPath)/\(sut.entityName).swift",
            "\(sut.testRelativeFolderPath)/\(sut.testEntityName).swift",
            mockFilePath
        ]
    }
}

struct UnitTestPromptCreator: PromptCreator {
    let unitTestFeature: UnitTestSpec
    func prompt() -> String {
        """
        look at \(unitTestFeature.sut.entityName), add required file to write unit tests for this class. \
        write any new mocks in \(unitTestFeature.mockFilePath) \
        implement the unit test functionality. IMPORTANT: implement the solution without asking any questions
        """
    }
}
