import SwiftUI

@MainActor
@Observable class DeckDetailViewModel {
    
    var openDeck: LocalDeck
    private var lastAPISavedDeck: APISavedDeck?
    
    init(deck: LocalDeck) {
        self.openDeck = deck
    }

    var isSaveEnabled: Bool {
        true
    }
}
