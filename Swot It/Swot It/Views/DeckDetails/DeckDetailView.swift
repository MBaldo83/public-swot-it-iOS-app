import SwiftUI

protocol DeckDetailViewHandler {
    func onAppear(_ deckId: String)
}

struct DeckDetailView: View {
    
    let handler: DeckDetailViewHandler
    @State private var viewModel: DeckDetailViewModel
    
    init(viewModel: DeckDetailViewModel,
         handler: DeckDetailViewHandler) {
        self.viewModel = viewModel
        self.handler = handler
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    TextField("Topic", text: $viewModel.topic)
                        .font(.subheadline)
                    
                    switch viewModel.openDeck {
                    case .initial:
                        // TODO remove this
                        VStack { }
                    case .loading:
                        ProgressView("Loading...")
                    case .loaded(let currentDeck):
                        let questionsBinding = Binding(
                            get: { currentDeck.questionSet },
                            set: {
                                viewModel.openDeck = .loaded(
                                    .init(
                                        apiId: currentDeck.apiId,
                                        topic: currentDeck.topic,
                                        questionSet: $0
                                    )
                                )
                            }
                        )
                        
                        EditableQuestionsListView(questions: questionsBinding)
                        
                    case .error(let error):
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            
            Button(action: {
                // Implement the review deck functionality here
                print("Review Deck button tapped!")
            }) {
                Text("Review Deck")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding([.leading, .trailing, .bottom])
            }
        }
        .onAppear {
            self.handler.onAppear(viewModel.apiId)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Implement the edit functionality here
                    print("Save button tapped!")
                }) {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .disabled(!viewModel.isSaveEnabled)
            }
        }
    }
    
    private func saveDeck() {
        // Implement the save functionality here
        print("Deck saved!")
    }
}



//struct DeckDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckDetailView(deck: Deck(topic: "Sample Topic", questionSet: []))
//    }
//}
