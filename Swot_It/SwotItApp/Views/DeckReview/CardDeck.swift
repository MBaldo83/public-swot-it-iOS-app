import SwiftUI

struct CardDeck: View {

    @Binding var deck: [DeckReviewViewModel.DeckViewState.QuestionCard]
    @Binding var index: Int
    private let canvasWidth: CGFloat = { UIScreen.main.bounds.width }()
    private let pageWidth: CGFloat = { UIScreen.main.bounds.width - 120 }()
    private let cardHeight: CGFloat = 380
    let submitResults: () -> Void
    
    private func moveIndexAnimated(
        delay: CGFloat = 0.0,
        _ indexChange: @escaping (Int) -> Int
    ) -> Void {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + delay,
            execute: {
                withAnimation(.linear(duration: 0.3)) {
                    self.index = indexChange(index)
                }
            }
        )
    }
    
    private func readyToSubmit() -> Bool {
        return deck.allSatisfy { $0.result != .unanswered }
    }

    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<deck.count, id: \.self) { index in
                        CardFlip(
                            card: $deck[index],
                            cardHeight: cardHeight,
                            onResultChange: { result in
                                if self.deck.indices.contains(self.index + 1) &&
                                    result != .unanswered {
                                    moveIndexAnimated(delay: 0.3) { $0 + 1 }
                                }
                            }
                        )
                        .frame(
                            width: pageWidth
                        )
                        .padding(
                            .horizontal,
                            (canvasWidth - pageWidth) / 2
                        )
                        .padding(.vertical)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollDisabled(true)
            .scrollPosition(id: Binding($index))
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            

            HStack {
                Button("", systemImage: "arrow.left.square") {
                    moveIndexAnimated() { $0 - 1 }
                }
                .opacity(deck.indices.contains(index - 1) ? 1 : 0)

                Spacer()

                Button("", systemImage: "checkmark.circle") {
                    submitResults()
                }
                .opacity(readyToSubmit() ? 1 : 0)
            }
            .font(.largeTitle)
            .padding()
        }
        .frame(width: canvasWidth)
    }
}

struct CardDeck_Previews: PreviewProvider {
    @State static var sampleDeck = [
        DeckReviewViewModel.DeckViewState.QuestionCard(
            id: UUID(),
            flipped: false,
            question: "What is the capital of France?",
            answer: "Paris",
            result: .correct
        ),
        DeckReviewViewModel.DeckViewState.QuestionCard(
            id: UUID(),
            flipped: true,
            question: "What is 2 + 2?",
            answer: "4",
            result: .correct
        )
    ]
    
    @State static var sampleIndex = 0
    
    static var previews: some View {
        CardDeck(
            deck: $sampleDeck,
            index: $sampleIndex,
            submitResults: {
                print("Results submitted")
            }
        )
        .previewDisplayName("Card Deck Preview")
    }
}


