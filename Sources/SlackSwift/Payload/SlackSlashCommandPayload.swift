import Vapor

public typealias SlashCommandPayload = Slack.SlashCommandPayload

extension Slack {

    public struct SlashCommandPayload: Content {

        internal(set) public var token: String

        internal(set) public var response_url: String

        internal(set) public var trigger_id: String?

        internal(set) public var user_id: String

        internal(set) public var user: User.Profile?

        internal(set) public var user_name: String?

        internal(set) public var command: String

        internal(set) public var text: String

        public var parameters: [String] { text.split(separator: " ").map { String($0) } }

        public func username(on index: Int) -> String? {
            guard index < parameters.count else { return nil }
            let raw = parameters[index]
            if raw.hasPrefix("<@") && raw.hasSuffix(">") && raw.firstIndex(of: "|") != nil {
                let content = raw.replacingOccurrences(of: "<@", with: "")
                                   .replacingOccurrences(of: ">", with: "")
                let subParams = content.split(separator: "|").map { String($0) }
                guard subParams.count == 2 else { return nil }
                return subParams[1]
            } else if raw.hasPrefix("@") {
                return raw.replacingOccurrences(of: "@", with: "")
            } else{
                return nil
            }
        }

        public func userId(on index: Int) -> String? {
            guard index < parameters.count else { return nil }
            let raw = parameters[index]
            if raw.hasPrefix("<@") && raw.hasSuffix(">") && raw.firstIndex(of: "|") != nil {
                let content = raw.replacingOccurrences(of: "<@", with: "")
                                   .replacingOccurrences(of: ">", with: "")
                let subParams = content.split(separator: "|").map { String($0) }
                guard subParams.count == 2 else { return nil }
                return subParams[0]
            } else{
                return nil
            }
        }

        public func parameter(on index: Int) -> String? {
            guard index < parameters.count else { return nil }
            return parameters[index]
        }

    }

}
