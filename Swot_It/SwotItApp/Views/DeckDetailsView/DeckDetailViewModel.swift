import SwiftUI

@MainActor
@Observable class DeckDetailViewModel {
    
    var openDeck: LocalDeck
    
    init(deck: LocalDeck) {
        self.openDeck = deck
    }

    var isSaveEnabled: Bool {
        true
    }
}
