import SwiftUI

protocol DecksViewHandler {
    func onAppear()
}

struct DecksView: View {
    let handler: DecksViewHandler
    
    @EnvironmentObject private var model: SwotItModel
    @Environment(Router.self) private var router: Router
    
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
                    Button(action: {
                        router.navigateTo(.deckDetail(deck))
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(deck.topic)
                                Spacer()
                                Text("Results: ").font(.caption)
                                HStack(spacing: 2) {
                                    BarView(percentage: deck.score.unanswered, color: .gray)
                                    BarView(percentage: deck.score.incorrect, color: .red)
                                    BarView(percentage: deck.score.hard, color: .orange)
                                    BarView(percentage: deck.score.correct, color: .green)
                                    BarView(percentage: deck.score.easy, color: .blue)
                                }
                                .frame(height: 10)
                            }
                        
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                    }
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

struct BarView: View {
    let percentage: Double
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: CGFloat(percentage), height: 10)
    }
}
