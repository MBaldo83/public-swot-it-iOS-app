import Foundation

struct AiderConfigYAMLFileWriter: FileWriter {
    func write(_ string: String) {
        do {
            try string.write(toFile: ".aider.conf.yml", atomically: true, encoding: .utf8)
        } catch {
            print("ERROR: \(error)")
        }
    }
}

struct DryRunFileWriter: FileWriter {
    func write(_ string: String) {
        print("*** DRY RUN FILE WRITE ***")
        print("\(string)")
    }
}
