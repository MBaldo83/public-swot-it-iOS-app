import Foundation

extension ViewSpecification {
    static func deckReviewViewFeatureSpec() -> ViewSpecification {
        .init(
            viewName: "DeckReviewView",
            viewFolderPath: "Swot_It/SwotItApp/Views/DeckReviewView/",
            models: [
                .init(
                    variableName: "viewState",
                    modelType: "DeckViewState",
                    modelPath: "Swot_It/SwotItApp/Views/DeckReviewView/DeckReviewView.swift"
                )
            ]
        )
    }
}

extension NavigationLink {
    static func deckReviewLinkToResults() -> NavigationLink {
        .init(from: .deckReviewViewFeatureSpec(),
              to: .deckResultsViewFeatureSpec(),
              triggerDescription: "when submit pressed",
              dataMappings: [
                .init(use: "DeckViewState.questionSubmissions", toCreate: "submissions")
              ]
        )
    }
}
