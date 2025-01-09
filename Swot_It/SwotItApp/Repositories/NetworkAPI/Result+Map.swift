import Foundation

extension Result {
    func map<SuccessDomain, ErrorDomain: Error>(
        successMap: (Success) -> SuccessDomain,
        errorMap: (Failure) -> ErrorDomain
    ) -> Result<SuccessDomain, ErrorDomain> {
        switch self {
        case .success(let success):
            return .success(successMap(success))
        case .failure(let error):
            return .failure(errorMap(error))
        }
    }
}
