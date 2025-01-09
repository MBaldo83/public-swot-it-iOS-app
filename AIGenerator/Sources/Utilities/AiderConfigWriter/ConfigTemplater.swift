import Foundation

struct YMLConfigTemplater: ConfigTemplater {
    func string(from config: any PromptConfig) -> String {
        return """
model: \(config.model)

## Enable/disable auto commit of LLM changes (default: True)
auto-commits: false

## specify a file to edit (can be used multiple times)
#file: xxx
## Specify multiple values like this:
file:
\(config.filesToAdd.reduce("") { (acc, file) in  return acc + "  - \(file)\n" } )
#  - zzz

## specify a read-only file (can be used multiple times)
read: \(config.readOnly)

## Always say yes to every confirmation
yes-always: true

## Control how often the repo map is refreshed. Options: auto, always, files, manual (default: auto)
map-refresh: always

## Specify the chat history file (default: .aider.chat.history.md)
chat-history-file: .aider.chat.history_\(config.chatHistoryID).md
## Restore the previous chat history messages (default: False)
restore-chat-history: true
"""
    }
}
