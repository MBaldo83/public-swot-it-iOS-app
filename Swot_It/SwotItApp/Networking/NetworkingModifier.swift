import Foundation

protocol NetworkingModifier {
    func send<T: Decodable>(request: URLRequest, upstream: some DecodingNetworkLayer, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError>
}

extension DecodingNetworkLayer {
  /// Modify the upstream decoding networking component using a networking modifier.
  public func modified(_ modifier: some NetworkingModifier) -> some DecodingNetworkLayer {
      Modified(upstream: self, modifier: modifier)
  }
}

private struct Modified<Upstream: DecodingNetworkLayer, Modifier: NetworkingModifier> {
  let upstream: Upstream
  let modifier: Modifier
}

extension Modified: DecodingNetworkLayer {
    func send<T: Decodable>(_ request: URLRequest, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError> {
        await modifier.send(request: request, upstream: upstream, decodeTo: type)
    }
}
