import Foundation

extension AiderControl {
    func currentTimeStampChatId() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Customize the format as needed
        return dateFormatter.string(from: Date())
    }
}
