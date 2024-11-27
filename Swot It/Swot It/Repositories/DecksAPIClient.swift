import Foundation

protocol RequestBuilding {
    func buildRequest(from endpoint: Endpoint) -> URLRequest?
}

class NetworkDecksAPIClient: DecksAPIClient {
    
    let authenticatedNetworking: () -> DecodingEndpointNetwork
    
    init(_ authenticatedNetworking: @escaping () -> DecodingEndpointNetwork) {
        self.authenticatedNetworking = authenticatedNetworking
    }
    
    func generateCards(
        topic: APISavedDeck.SanitizedTopic,
        count: APISavedDeck.SanitizedQuestionCount
    ) async -> Result<[Question], LoadableResourceError> {
        
        return await authenticatedNetworking()
            .send(
                DecksAPI.generate(topic: topic, count: count),
                decodeTo: DecksAPI.DeckNetworkModel.self
            )
            .map(
                successMap: { deckResponse in
                    deckResponse.question_set.questions.map{ Question(question: $0.question, answer: $0.answer) }
                },
                errorMap: { $0.mapToDomain() }
            )
    }
    
    func loadDecks() async -> Result<[APISavedDeckSummary], LoadableResourceError> {
        return await authenticatedNetworking()
            .send(
                DecksAPI.loadDecks,
                decodeTo: [DecksAPI.DeckListNetworkModel].self
            )
            .map(
                successMap: { deckNetworkModels in
                    deckNetworkModels.map { deckListNetworkModel in
                            .init(
                                apiId: deckListNetworkModel.id,
                                topic: deckListNetworkModel.topic
                            )
                    }
                },
                errorMap: { $0.mapToDomain() }
            )
    }
    
    func loadDeck(_ id: String) async -> Result<APISavedDeck, LoadableResourceError> {
        return await authenticatedNetworking()
            .send(
                DecksAPI.loadDeck(id: id),
                decodeTo: DecksAPI.DeckNetworkModel.self
            )
            .map(
                successMap: { deckNetworkModel in
                    APISavedDeck(
                        apiId: id,
                        topic: deckNetworkModel.topic,
                        questionSet: deckNetworkModel.question_set.questions.map { question in
                            Question(question: question.question, answer: question.answer)
                        }
                    )
                },
                errorMap: { $0.mapToDomain() }
            )
    }
    
    
    func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic) async -> Result<String, LoadableResourceError> {
        return await authenticatedNetworking()
            .send(
                DecksAPI.save(deck: .init(topic: topic.topic, questions: deck)),
                decodeTo: DecksAPI.DeckIdentifier.self
            )
            .map(
                successMap: { $0.id },
                errorMap: { $0.mapToDomain() }
            )
    }
    
    func updateDeck(_ deck: APISavedDeck) async -> Result<String, LoadableResourceError> {
        return await authenticatedNetworking()
            .send(
                DecksAPI.update(deck: .init(from: deck), identifier: .init(id: deck.apiId)),
                decodeTo: DecksAPI.DeckIdentifier.self
            )
            .map(
                successMap: { $0.id  },
                errorMap: { $0.mapToDomain() }
            )
    }
}

extension DecksAPI.DeckNetworkModel {
    
    init(topic: String, questions: [Question]) {
        
        self.topic = topic
        self.question_set = .init(
            questions: questions.map { question in
                DecksAPI.QuestionNetworkModel(question: question.question, answer: question.answer)
            }
        )
    }
    
    init(from deck: APISavedDeck) {
        self.topic = deck.topic
        self.question_set = DecksAPI.QuestionSetNetworkModel(
            questions: deck.questionSet.map { question in
                DecksAPI.QuestionNetworkModel(question: question.question, answer: question.answer)
            }
        )
    }
}
