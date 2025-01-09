import Foundation

extension AiderControl {
    
    func generateDeckResultsNavigation() {
        
        let deckResultsViewFeatureSpec = ViewSpecification.deckResultsViewFeatureSpec()
        let chatHistoryId = UUID().uuidString
        
        let newRoutePromptCreator = NewNavigationRoutePromptCreator(
            newView: deckResultsViewFeatureSpec,
            chatHistoryId: chatHistoryId
        )
        
        let newViewBuilderPromptCreator = NewNavigationViewBuilderPromptCreator(
            newView: deckResultsViewFeatureSpec,
            chatHistoryId: chatHistoryId
        )
        
        let newNavigationLinkPromptCreator = NewNavigationLinkGeneratorPromptCreator(
            link: .deckReviewLinkToResults(),
            chatHistoryId: chatHistoryId
        )
        
        let inferencingTuples: [(promptCreator: PromptCreator, promptConfig: PromptConfig)] = [
            (newRoutePromptCreator, newRoutePromptCreator),
            (newViewBuilderPromptCreator, newViewBuilderPromptCreator),
            (newNavigationLinkPromptCreator, newNavigationLinkPromptCreator)
        ]
        
        for tuple in inferencingTuples {
            promptPipelineRunner.inference(
                using: tuple.promptCreator,
                with: tuple.promptConfig
            )
        }
    }
}
