import Foundation

protocol LoadOpenDeckUseCase {
    func loadOpenDeck(_ deckId: String) async
}

class LoadDeckUseCaseDeckDetailViewHandler: DeckDetailViewHandler {
    
    let deckResourceManagementUseCase: DeckResourceManagementUseCase
    
    init(deckResourceManagementUseCase: DeckResourceManagementUseCase) {
        self.deckResourceManagementUseCase = deckResourceManagementUseCase
    }
    
    func updatedDeck(_ deck: LocalDeck) {
        Task {
            await deckResourceManagementUseCase.updateLocalDeck(deck)
        }
    }
}
