import Foundation

struct DryRunShellExecutable: ShellExecutable {
    static func shellContinuousPrint(_ command: String) {
        print(command)
    }
    
    static func shell(_ command: String) -> String {
        print(command)
        return ""
    }
}

struct ShellExecutor: ShellExecutable {
    
    static func shellContinuousPrint(_ command: String) {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        
        // New: Set up a file handle to read output asynchronously
        let outputHandle = pipe.fileHandleForReading
        
        outputHandle.readabilityHandler = { handle in
            let data = handle.availableData
            if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                print(output, terminator: "") // Print output in real-time
            }
        }
        
        task.launch()
        
        // Wait for the task to complete
        task.waitUntilExit()
        
        // New: Clean up the readability handler
        outputHandle.readabilityHandler = nil
    }
    
    static func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        return output
    }
}
