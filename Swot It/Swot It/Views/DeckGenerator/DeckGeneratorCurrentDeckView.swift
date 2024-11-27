import SwiftUI

struct DeckGeneratorSimplifiedStageView: View {
    let generationStage: LoadableResource<DeckGenerationProcessResource>
    @EnvironmentObject private var model: SwotItModel

    var body: some View {
        switch generationStage {
        case .initial:
            Text("Please enter a topic and generate cards.")
                .foregroundColor(.secondary)
        case .loading:
            ProgressView("Loading...")
            
        case .loaded(let resource):
            
            switch resource {
            case .generatedNewDeck(let questions):
                let questionsBinding = Binding(
                    get: { questions.questions },
                    set: {
                        model.simplifiedDeckGenerationProcess = .loaded(.generatedNewDeck(.init(topic: questions.topic, questions: $0)))
                    }
                )
                EditableQuestionsListView(questions: questionsBinding)
            case .savedDeck(let deck):
                let questionsBinding = Binding(
                get: { deck.questionSet },
                set: {
                    model.simplifiedDeckGenerationProcess = .loaded(.savedDeck(.init(apiId: deck.apiId, topic: deck.topic, questionSet: $0)))
                }
                )
                EditableQuestionsListView(questions: questionsBinding)
            }
            
        case .error(let loadableResourceError):
            Text("Error: \(loadableResourceError.localizedDescription)")
                .foregroundColor(.red)
        }
    }
}
