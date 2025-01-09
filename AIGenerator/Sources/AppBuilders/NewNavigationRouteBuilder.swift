import Foundation

struct NewNavigationRoutePromptCreator: PromptCreator {
    let newView: ViewSpecification
    let chatHistoryId: String
    func prompt() -> String {
        """
        add a new Router.Route enum case called \(newView.routeName) \
        that is initialised with variables: \(newView.modelVariablesString). \
        Keep the solution simple, don't add any new files. IMPORTANT: implement the solution without asking any questions
        """
    }
}

extension NewNavigationRoutePromptCreator: PromptConfig {
    var filesToAdd: [String] { newView.filesNeededToCreateNavigationRoute }
    var chatHistoryID: String { chatHistoryId }
}

struct NewNavigationViewBuilderPromptCreator: PromptCreator {
    let newView: ViewSpecification
    let chatHistoryId: String
    func prompt() -> String {
        """
        In the class SwiftUIRouteViewBuilder, function view(for route: Router.Route) \
        implement the new switch case \(newView.routeName) returning a new \(newView.viewName) \
        initialised with variables: \(newView.modelVariablesString). \
        This is a first draft, keep the solution simple. IMPORTANT: implement the solution without asking any questions
        """
    }
}

extension NewNavigationViewBuilderPromptCreator: PromptConfig {
    var filesToAdd: [String] { newView.filesNeededToCreateNavigationViewBuilder }
    var chatHistoryID: String { chatHistoryId }
}

struct NewNavigationLinkGeneratorPromptCreator: PromptCreator {
    let link: NavigationLink
    let chatHistoryId: String
    func prompt() -> String {
        """
        In \(link.from.viewName) when \(link.triggerDescription), use the router Environment variable \
        to navigate to \(link.to.viewName). \
        \(link.modelVariablesFullMappingDescription) \
        This is a first draft, keep the solution simple. IMPORTANT: implement the solution without asking any questions
        """
    }
}

extension NewNavigationLinkGeneratorPromptCreator: PromptConfig {
    var filesToAdd: [String] {
        var filePaths = link.from.filesNeededNavigate
        filePaths.append(contentsOf: link.to.filesNeededNavigate)
        filePaths.append("Swot_It/SwotItApp/Navigation/Router.swift")
        return filePaths
    }
    var chatHistoryID: String { chatHistoryId }
}

struct NavigationLink {
    let from: ViewSpecification
    let to: ViewSpecification
    let triggerDescription: String
    let dataMappings: [DataMapping]
    
    struct DataMapping {
        let use: String
        let toCreate: String
    }
    
    var modelVariablesFullMappingDescription: String {
        let variables = dataMappings.map { "use \($0.use) to create \($0.toCreate)" }
        return variables.joined(separator: " and ")
    }
}

extension ViewSpecification {
    
    var pathToViewOnceCreated: String {
        "\(viewFolderPath)\(viewName).swift"
    }
    
    var routeName: String {
        let modifiedName = viewName.replacingOccurrences(of: "View", with: "", options: .backwards)
        return modifiedName.prefix(1).lowercased() + modifiedName.dropFirst()
    }
    
    var filesNeededToCreateNavigationRoute: [String] {
        var models = models.map { $0.modelPath }
        models.append(pathToViewOnceCreated)
        models.append("Swot_It/SwotItApp/Navigation/Router.swift")
        return models
    }
    
    var filesNeededToCreateNavigationViewBuilder: [String] {
        var models = filesNeededToCreateNavigationRoute
        models.append("Swot_It/SwotItApp/Navigation/SwiftUIRouteViewBuilder.swift")
        return models
    }
    
    var filesNeededNavigate: [String] {
        var models = models.map { $0.modelPath }
        models.append(pathToViewOnceCreated)
        return models
    }
}
