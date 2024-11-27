import SwiftUI

protocol BuildDeckViewHandler {
    func generateCardsTapped(topic: APISavedDeck.SanitizedTopic, count: APISavedDeck.SanitizedQuestionCount)
    func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic)
    func updateDeck(_ deck: APISavedDeck)
}

struct DeckGeneratorView: View {
    let handler: BuildDeckViewHandler
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
        
        guard let topicValidated = APISavedDeck.SanitizedTopic(topic: newTopic) else {
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
                    apiId: deck.apiId,
                    topic: topicValidated.topic,
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
        guard let topicValidated = APISavedDeck.SanitizedTopic(topic: newTopic),
              let countValidated = APISavedDeck.SanitizedQuestionCount(count: numberOfCards) else {
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
        struct NoOpBuildDeckViewHandler: BuildDeckViewHandler {
            func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic) { }
            func updateDeck(_ deck: APISavedDeck) { }
            func generateCardsTapped(topic: APISavedDeck.SanitizedTopic, count: APISavedDeck.SanitizedQuestionCount) { }
        }
        
        return DeckGeneratorView(
            handler: NoOpBuildDeckViewHandler()
        )
    }
}
