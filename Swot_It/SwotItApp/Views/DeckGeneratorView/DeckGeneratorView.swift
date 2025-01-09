import SwiftUI

protocol DeckGeneratorViewHandler {
    func generateCardsTapped(topic: QuestionsGenerated.SanitizedTopic, count: QuestionsGenerated.SanitizedQuestionCount)
    func saveNewDeck(_ deck: [Question], topic: QuestionsGenerated.SanitizedTopic)
    func updateDeck(_ deck: LocalDeck)
}

struct DeckGeneratorView: View {
    let handler: DeckGeneratorViewHandler
    @EnvironmentObject private var model: SwotItModel
    @State private var newTopic: String = ""
    @State private var numberOfCards: Int = 10
    @State private var scrollOffset: CGFloat = 0
    
    private var topVStackHeight: CGFloat { headlineHeight + topicTextFieldHeight }
    private let headlineHeight: CGFloat = 20
    private let topicTextFieldHeight: CGFloat = 100
    private let coordinateSpaceName = "scroll"
    
    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ViewOffsetKey.self,
                        value: geometry.frame(
                            in: .named(coordinateSpaceName)
                        ).origin.y
                    )
                }
                .frame(height: 0)
                
                TopicInputView(
                    topic: $newTopic,
                    headlineHeight: headlineHeight,
                    topicTextFieldHeight: topicTextFieldHeight
                )
                
                GenerateCardsToolbar(
                    numberOfCards: $numberOfCards,
                    generateAction: generateCardsTapped,
                    isEnabled: isGenerateButtonEnabled,
                    saveAction: saveActionForToolbar,
                    isSaveEnabled: isSaveButtonEnabled
                )
                
                DeckGeneratorSimplifiedStageView(
                    generationStage: model.simplifiedDeckGenerationProcess
                )
            }
            .padding()
        }
        .applyHeightOffsetScrollViewOverlay(
            coordinateSpaceName: coordinateSpaceName,
            heightOffsetThreshold: topVStackHeight,
            preferenceKey: ViewOffsetKey.self,
            overlayContentView: {
                GenerateCardsToolbar(
                    numberOfCards: $numberOfCards,
                    generateAction: generateCardsTapped,
                    isEnabled: isGenerateButtonEnabled,
                    saveAction: saveActionForToolbar,
                    isSaveEnabled: isSaveButtonEnabled
                )
            }
        )
    }
    
    private func saveActionForToolbar() {
        
        guard let topicValidated = QuestionsGenerated.SanitizedTopic(topic: newTopic) else {
            // TODO display error
            return
        }
        
        // When we've generated a question set we can save this new
        if case .loaded(.generatedNewDeck(let questions)) = model.simplifiedDeckGenerationProcess {
            handler.saveNewDeck(questions.questions, topic: topicValidated)
        }
        // When we've already saved and we're making updates
        if case .loaded(.savedDeck(let deck)) = model.simplifiedDeckGenerationProcess {
            handler.updateDeck(
                .init(
                    localId: deck.localId,
                    topic: deck.topic,
                    questionSet: deck.questionSet
                )
            )
        }
    }
    
    private var isSaveButtonEnabled: Bool {
        
        if case .loaded = model.simplifiedDeckGenerationProcess {
            return true
        }
        
        return false
    }
    
    private func generateCardsTapped() {
        guard let topicValidated = QuestionsGenerated.SanitizedTopic(topic: newTopic),
              let countValidated = QuestionsGenerated.SanitizedQuestionCount(count: numberOfCards) else {
            // TODO display error
            return
        }
        handler.generateCardsTapped(topic: topicValidated, count: countValidated)
    }
    
    private var isGenerateButtonEnabled: Bool {
        return model.simplifiedDeckGenerationProcess != .loading
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct BuildDeckView_Previews: PreviewProvider {
    static var previews: some View {
        struct NoOpBuildDeckViewHandler: DeckGeneratorViewHandler {
            func saveNewDeck(_ deck: [Question], topic: QuestionsGenerated.SanitizedTopic) { }
            func updateDeck(_ deck: LocalDeck) { }
            func generateCardsTapped(topic: QuestionsGenerated.SanitizedTopic, count: QuestionsGenerated.SanitizedQuestionCount) { }
        }
        
        return DeckGeneratorView(
            handler: NoOpBuildDeckViewHandler()
        )
    }
}
