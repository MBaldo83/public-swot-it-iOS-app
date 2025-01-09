import SwiftUI

struct DeckDetailContentView: View {
    
    @Binding var openDeck: LocalDeck
    let onReviewDeck: (LocalDeck) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Topic:")
                TextField("Topic", text: $openDeck.topic)
                
            }.font(.subheadline)
            
            ScrollView {
                EditableLocalQuestionsListView(questions: $openDeck.questionSet)
            }
            
            Button(action: {
                onReviewDeck(openDeck)
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
        .padding()
    }
}

struct DeckDetailContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeckDetailContentView(
                openDeck:.constant(LocalDeck(
                    localId: UUID(),
                    topic: "Sample Topic",
                    questionSet: [
                        .init(
                            id: UUID(),
                            question: "Who Banished Henry to France?",
                            answer: "Richard II",
                            submissions: []
                        )
                        ]
                )),
                onReviewDeck: { _ in }
            )
            .previewDisplayName("Loaded Content")
        }
    }
}
