import SwiftUI

struct GenerateCardsToolbar: View {
    @Binding var numberOfCards: Int
    var generateAction: () -> Void
    var isEnabled: Bool
    var saveAction: () -> Void
    var isSaveEnabled: Bool
    
    var body: some View {
        HStack {
            Text("Cards:")
                .font(.subheadline)
            TextField("", value: $numberOfCards, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 100)
            Spacer()
            Button(action: generateAction) {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                    .font(.title2)
                    .disabled(!isEnabled) // Disable the button based on isEnabled
            }
            Button(action: saveAction) {
                Image(systemName: "tray.and.arrow.down")
                    .foregroundColor(.green)
                    .font(.title2)
            }
            .disabled(!isSaveEnabled)
        } 
        .padding()
        .background(Color.white)
    }
}
