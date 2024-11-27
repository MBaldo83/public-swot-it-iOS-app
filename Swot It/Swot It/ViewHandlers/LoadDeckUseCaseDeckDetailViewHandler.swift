import Foundation

protocol LoadOpenDeckUseCase {
    func loadOpenDeck(_ deckId: String) async
}

class LoadDeckUseCaseDeckDetailViewHandler: DeckDetailViewHandler {
    
    let loadOpenDeckUseCase: LoadOpenDeckUseCase
    
    init(loadOpenDeckUseCase: LoadOpenDeckUseCase) {
        self.loadOpenDeckUseCase = loadOpenDeckUseCase
    }
    
    func onAppear(_ deckId: String) {
        Task {
            await loadOpenDeckUseCase.loadOpenDeck(deckId)
        }
    }
}
