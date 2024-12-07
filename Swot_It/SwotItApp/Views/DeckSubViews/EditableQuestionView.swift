import SwiftUI

struct EditableQuestionView: View {
    @Binding var questionString: String
    @Binding var answerString: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)

            HStack(spacing: 8) {
                TextEditor(text: $questionString)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                
                DottedLine()
                    .frame(width: 1)
                    .padding(.vertical, 4)
                
                TextEditor(text: $answerString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
            }
            .padding()
        }
    }
}

struct DottedLine: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
            .foregroundColor(.gray)
        }
    }
}

// Add this preview struct
struct CardInListView_Previews: PreviewProvider {
    static var previews: some View {
        EditableQuestionView(
            questionString: .constant("What is the capital of France?"),
            answerString: .constant("Paris")
        )
        .frame(height: 200)
    }
}
