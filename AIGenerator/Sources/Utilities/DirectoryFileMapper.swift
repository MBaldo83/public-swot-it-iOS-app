import Foundation

protocol FileHandler {
    func handle(fileName: String, in directory: String)
}

struct DirectoryFileMapper {
    
    let relativePath: String
    
    func mapFiles(_ handler: (String, String) -> Void) {
        
        // Execute the command and capture the output
        let fileListOutput = ShellExecutor.shell("ls \(relativePath)")
        let fileNames = fileListOutput.split(separator: "\n").map { String($0) }
        
        for file in fileNames {
            handler(file, relativePath)
        }
    }
}
