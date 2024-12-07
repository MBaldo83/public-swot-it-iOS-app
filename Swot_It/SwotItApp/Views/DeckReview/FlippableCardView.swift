import SwiftUI

struct CardFlip: View {
    
    @Binding var card: DeckReviewViewModel.DeckViewState.QuestionCard
    private let animationDelay: CGFloat = 0.35
    let cardHeight: CGFloat
    let onResultChange: (DeckReviewViewModel.DeckViewState.QuestionCard.Result) -> Void
    
    var body: some View {
        VStack {
            ZStack {
                CardAnswerBack(
                    card: $card
                )
                .frame(width: 250, height: cardHeight)
                .rotation3DEffect(
                    .degrees(card.flipped ? 0 : -90), axis: (x: 0, y: 1, z: 0)
                )
                .animation(
                    card.flipped ? .linear.delay(animationDelay) : .linear,
                    value: card.flipped
                )
                
                CardQuestionFront(
                    card: $card
                )
                .frame(width: 250, height: cardHeight)
                .rotation3DEffect(
                    .degrees(card.flipped ? 90 : 0), axis: (x: 0, y: 1, z: 0)
                )
                .animation(
                    card.flipped ? .linear : .linear.delay(animationDelay),
                    value: card.flipped
                )
            }
            
            VStack {
                Text("How did you do?")
                    .foregroundStyle(.gray)
                    .font(.caption)
                Picker(
                    "",
                    selection: $card.result
                ) {
                    ForEach(
                        DeckReviewViewModel.DeckViewState.QuestionCard.Result
                            .pickableCases(), id: \.self
                    ) { option in
                        Text(option.stringValue())
                    }
                }
                .font(.caption)
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: card.result) { oldvalue, newValue in
                    print("Picker selection changed to: \(newValue)")
                    onResultChange(newValue)
                }
            }
            .opacity(card.flipped ? 1 : 0)
            .animation(
                card.flipped ? .linear : .linear.delay(animationDelay),
                value: card.flipped
            )
            .padding()
        }
    }
}

struct CardQuestionFront: View {
    
    @Binding var card: DeckReviewViewModel.DeckViewState.QuestionCard
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .cornerRadius(12)
                .shadow(radius: 8)
            VStack {
                Text("Question")
                    .foregroundStyle(.gray)
                    .font(.caption)
                Spacer()
                Text(card.question)
                    .foregroundStyle(.gray)
                    .font(.title2)
                Spacer()
                Text("tap to flip")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            .padding()
        }
        .onTapGesture {
            card.flipped.toggle()
        }
    }
}

struct CardAnswerBack: View {
    
    @Binding var card: DeckReviewViewModel.DeckViewState.QuestionCard
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .cornerRadius(12)
                .shadow(radius: 8)
            
            VStack {
                Text("Answer")
                    .foregroundStyle(.gray)
                    .font(.caption)
                Spacer()
                Text(card.question)
                    .foregroundStyle(.gray)
                    .font(.caption)
                Text(card.answer)
                    .foregroundStyle(.gray)
                    .font(.title2)
                Spacer()
            }
            .padding()
        }
        .onTapGesture {
            card.flipped.toggle()
        }
    }
}

struct CardFlip_Previews: PreviewProvider {
    
    static func createPreviewCard(flipped: Bool) -> DeckReviewViewModel.DeckViewState.QuestionCard {
        return DeckReviewViewModel.DeckViewState.QuestionCard(
            id: UUID(),
            flipped: flipped,
            question: "What is the capital of France?",
            answer: "Paris",
            result: .correct
        )
    }
    
    static var previews: some View {
        Group {
            CardFlip(card: .constant(createPreviewCard(flipped: true)), cardHeight: 380, onResultChange: {_ in })
                .previewDisplayName("Flipped Card")
            
            CardFlip(card: .constant(createPreviewCard(flipped: false)), cardHeight: 380, onResultChange: {_ in })
                .previewDisplayName("Not Flipped Card")
        }
    }
}
