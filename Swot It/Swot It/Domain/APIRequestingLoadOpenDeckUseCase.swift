import Foundation

protocol LoadOpenDeckUseCaseOutput {
    func setOpenDeck(_ deck: LoadableResource<APISavedDeck>) async
}

class APIRequestingLoadOpenDeckUseCase: LoadOpenDeckUseCase {
    
    let apiClient: DecksAPIClient
    let output: LoadOpenDeckUseCaseOutput
    
    init(apiClient: DecksAPIClient,
         output: LoadOpenDeckUseCaseOutput
    ) {
        self.apiClient = apiClient
        self.output = output
    }
    
    func loadOpenDeck(_ deckId: String) async {
        
        await output.setOpenDeck(.loading)
        
        let deckLoadResult = await apiClient.loadDeck(deckId)
        
        switch deckLoadResult {
        case .success(let success):
            await output.setOpenDeck(.loaded(success))
        case .failure(let failure):
            await output.setOpenDeck(.error(failure))
        }
    }
}
