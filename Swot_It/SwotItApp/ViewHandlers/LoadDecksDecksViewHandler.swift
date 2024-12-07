import Foundation

protocol LoadDecksUseCase {
    func loadDecks() async
}

class LoadDecksDecksViewHandler: DecksViewHandler {
    private let loadDecksUseCase: LoadDecksUseCase

    init(loadDecksUseCase: LoadDecksUseCase) {
        self.loadDecksUseCase = loadDecksUseCase
    }

    func onAppear() {
        Task {
            await loadDecksUseCase.loadDecks()
        }
    }
}
