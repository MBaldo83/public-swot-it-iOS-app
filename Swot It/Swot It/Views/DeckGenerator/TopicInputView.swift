import SwiftUI

struct TopicInputView: View {
    @Binding var topic: String
    let headlineHeight: CGFloat
    let topicTextFieldHeight: CGFloat
    
    var body: some View {
        VStack {
            Text("What do you want to study?")
                .font(.headline)
                .frame(height: headlineHeight)
            
            TextEditor(text: $topic)
                .frame(height: topicTextFieldHeight)
                .border(Color.gray, width: 1)
        }
    }
}
