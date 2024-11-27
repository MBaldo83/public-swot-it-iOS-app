import SwiftUI

struct EditableQuestionsListView: View {
    
    @Binding var questions: [Question]
    
    var body: some View {
        if !questions.isEmpty {
            ForEach($questions) { $question in
                EditableQuestionView(question: $question)
                    .frame(height: 200)
            }
        } else {
            Text("No cards generated yet")
                .foregroundColor(.secondary)
        }
    }
}
