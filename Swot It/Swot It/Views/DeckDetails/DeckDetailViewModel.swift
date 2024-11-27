import SwiftUI

@MainActor
@Observable class DeckDetailViewModel {
    
    var openDeck: LoadableResource<APISavedDeck>
    private var lastAPISavedDeck: APISavedDeck?
    var topic: String
    var apiId: String
    
    init(deck: APISavedDeckSummary) {
        self.openDeck = .loading
        self.topic = deck.topic
        self.apiId = deck.apiId
    }

    var isSaveEnabled: Bool {
        if case .loaded(let deck) = openDeck {
            return deck != lastAPISavedDeck
        }
        return false
    }
}

extension DeckDetailViewModel: LoadOpenDeckUseCaseOutput {
    
    func setOpenDeck(_ loadableDeck: LoadableResource<APISavedDeck>) async {
        openDeck = loadableDeck
        if case .loaded(let deck) = loadableDeck {
            // save this so we know if the user has edited
            lastAPISavedDeck = deck
            topic = deck.topic
        }
    }
}
