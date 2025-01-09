import Foundation

struct ViewSpecification {
    let viewName: String
    let viewFolderPath: String
    let models: [ViewData]
}

struct ViewData {
    let variableName: String
    let modelType: String
    let modelPath: String
}

extension ViewSpecification {
    var modelVariablesString: String {
        let variables = models.map { "\($0.variableName) = \($0.modelType)" }
        return variables.joined(separator: " and ")
    }
}

extension ViewSpecification {
    var filesNeededToCreate: [String] {
        return models.map { $0.modelPath }
    }
}

extension NewViewBuilder: PromptConfig {
    var filesToAdd: [String] {
        newView.filesNeededToCreate
    }
}

struct NewViewBuilder: PromptCreator {
    
    let newView: ViewSpecification
    
    func prompt() -> String {

        """
make a new view \(newView.viewName) in \(newView.viewFolderPath) \
that is initialised with variables: \(newView.modelVariablesString). \
keep the body of the view empty \
This is a first draft, keep the solution simple. IMPORTANT: implement the solution without asking any questions
"""
    }
}
