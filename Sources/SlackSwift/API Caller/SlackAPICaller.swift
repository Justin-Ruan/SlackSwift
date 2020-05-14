import Vapor

extension Slack {

    public class APICaller {

        internal init() { }

        public func makeCall(using client: Client, token: String, method: SlackMethod) throws -> Future<Response> {

            switch method {
            case .view(let subMethod):
                return client.send(subMethod.httpMethod, headers: ["Authorization": "Bearer \(token)"], to: method.route) { req in
                    try subMethod.encodeContent(on: req)
                }
            }

        }

    }

}
