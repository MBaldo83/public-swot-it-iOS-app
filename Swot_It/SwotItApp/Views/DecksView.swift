import SwiftUI

protocol DecksViewHandler {
    func onAppear()
}

struct DecksView: View {
    let handler: DecksViewHandler
    
    @EnvironmentObject private var model: SwotItModel
    
    var body: some View {
        VStack {
            switch model.localUserSavedDecks {
            case .initial:
                Text("No Decks")
                    .foregroundColor(.secondary)
            case .loading:
                ProgressView("Loading...")
            case .loaded(let currentDecks):
                List(currentDecks) { deck in
                    NavigationLink(
                        deck.topic,
                        value: Router.Route.deckDetail(deck)
                    )
                }
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            handler.onAppear()
        }
    }
}
