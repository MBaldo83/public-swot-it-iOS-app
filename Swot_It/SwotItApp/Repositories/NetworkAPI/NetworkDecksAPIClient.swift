import Foundation

protocol DecodingEndpointNetwork {
    func send<T: Decodable>(_ endpoint: Endpoint, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError>
}

class NetworkDecksAPIClient: DecksAPIClient {
    
    let authenticatedNetworking: () -> DecodingEndpointNetwork
    
    init(_ authenticatedNetworking: @escaping () -> DecodingEndpointNetwork) {
        self.authenticatedNetworking = authenticatedNetworking
    }
    
    func generateCards(
        topic: QuestionsGenerated.SanitizedTopic,
        count: QuestionsGenerated.SanitizedQuestionCount
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
}
