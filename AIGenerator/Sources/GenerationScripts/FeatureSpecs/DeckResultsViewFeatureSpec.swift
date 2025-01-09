import Foundation

extension ViewSpecification {
    static func deckResultsViewFeatureSpec() -> ViewSpecification {
        .init(
            viewName: "DeckResultsView",
            viewFolderPath: "Swot_It/SwotItApp/Views/DeckResultsView/",
            models: [
                .init(
                    variableName: "submissions",
                    modelType: "[QuestionSubmission]",
                    modelPath: "Swot_It/SwotItApp/Domain/QuestionSubmission.swift"
                )
            ]
        )
    }
}
