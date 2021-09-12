import Vapor

extension Slack.SlackMethod {

    public enum ViewSubMethod {

        case open(triggerId: String, view: View)

        case publish(userId: String, view: View, hash: String?)

        case push(triggerId: String, view: View)

        case updateWithExternald(externalId: String, view: View, hash: String?)

        case update(viewId: String, view: View, hash: String?)

        internal var path: String { "view.\(apiName)" }

        internal var apiName: String {
            switch self {
            case .open: return "open"
            case .publish: return "publish"
            case .push: return "push"
            case .update, .updateWithExternald: return "update"
            }
        }

        internal var httpMethod: HTTPMethod { .POST }

        private struct ViewPayload: OnlyEncodableContent {
            var trigger_id: String?
            var view: View
            var user_id: String?
            var hash: String?
            var external_id: String?
            var view_id: String?

            private init(view: View) {
                self.view = view
            }

            static func open(triggerId: String, view: View) -> ViewPayload {
                var retVal = ViewPayload(view: view)
                retVal.trigger_id = triggerId
                return retVal
            }

            static func publish(userId: String, view: View, hash: String?) -> ViewPayload {
                var retVal = ViewPayload(view: view)
                retVal.user_id = userId
                retVal.hash = hash
                return retVal
            }

            static func push(triggerId: String, view: View) -> ViewPayload {
                var retVal = ViewPayload(view: view)
                retVal.trigger_id = triggerId
                return retVal
            }

            static func update(viewId: String, view: View, hash: String?) -> ViewPayload {
                var retVal = ViewPayload(view: view)
                retVal.view_id = viewId
                retVal.hash = hash
                return retVal
            }

            static func update(externalId: String, view: View, hash: String?) -> ViewPayload {
                var retVal = ViewPayload(view: view)
                retVal.external_id = externalId
                retVal.hash = hash
                return retVal
            }
        }

        private struct PublishPayload: OnlyEncodableContent {
            var user_id: String
            var view: View
            var hash: String?

            init(userId: String, view: View, hash: String?) {
                self.user_id = userId
                self.view = view
                self.hash = hash
            }

        }

        internal func encodeContent(on req: (inout ClientRequest)) throws {
            switch self {
            case .open(let triggerId, let view):
                try req.content.encode(ViewPayload.open(triggerId: triggerId, view: view))
            case .publish(let userId, let view, let hash):
                try req.content.encode(ViewPayload.publish(userId: userId, view: view, hash: hash))
            case .push(let triggerId, let view):
                try req.content.encode(ViewPayload.push(triggerId: triggerId, view: view))
            case .updateWithExternald(let externalId, let view, let hash):
                try req.content.encode(ViewPayload.update(externalId: externalId, view: view, hash: hash))
            case .update(let viewId, let view, let hash):
                try req.content.encode(ViewPayload.update(viewId: viewId, view: view, hash: hash))
            }
        }

    }

}

fileprivate protocol OnlyEncodableContent: Content {

}

fileprivate extension OnlyEncodableContent {

    init(from decoder: Decoder) throws { fatalError() }

}
