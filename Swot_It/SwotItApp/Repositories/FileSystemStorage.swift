import Foundation

class FileSystemStorage: DeckStorage {
    static let shared: FileSystemStorage? = FileSystemStorage()
    
    private let fileManager = FileManager.default
    private let directoryURL: URL
    
    private init?() {
        // Safely get the documents directory URL
        guard let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        self.directoryURL = directoryURL
    }
    
    func saveDeck(_ deck: LocalDeck) throws {
        let fileURL = directoryURL.appendingPathComponent("\(deck.localId).json")
        let encoder = JSONEncoder()
        let data = try encoder.encode(deck)
        try data.write(to: fileURL)
    }
    
    func loadAllDecks() throws -> [LocalDeck] {
        let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
        var decks = [LocalDeck]()
        let decoder = JSONDecoder()
        
        for fileURL in fileURLs {
            let data = try Data(contentsOf: fileURL)
            let deck = try decoder.decode(LocalDeck.self, from: data)
            decks.append(deck)
        }
        
        return decks
    }
}
