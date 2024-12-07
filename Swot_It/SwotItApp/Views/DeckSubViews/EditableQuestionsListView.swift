import SwiftUI

struct EditableLocalQuestionsListView: View {
    
    @Binding var questions: [LocalDeck.Question]
    
    var body: some View {
        if !questions.isEmpty {
            ForEach($questions) { $question in
                EditableQuestionView(
                    questionString: $question.question,
                    answerString: $question.answer
                )
                .frame(height: 200)
            }
        } else {
            Text("No cards generated yet")
                .foregroundColor(.secondary)
        }
    }
}

struct EditableQuestionsListView: View {
    
    @Binding var questions: [Question]
    
    var body: some View {
        if !questions.isEmpty {
            ForEach($questions) { $question in
                EditableQuestionView(
                    questionString: $question.question,
                    answerString: $question.answer
                )
                .frame(height: 200)
            }
        } else {
            Text("No cards generated yet")
                .foregroundColor(.secondary)
        }
    }
}
