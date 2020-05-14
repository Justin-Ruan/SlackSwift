import Vapor

public typealias SlashCommandPayload = Slack.SlashCommandPayload

extension Slack {

    public struct SlashCommandPayload: Content {

        var token: String

        var response_url: String

        var trigger_id: String?

        var user_id: String

        var user: User.Profile?

        var user_name: String?

        var command: String

        var text: String

        var parameters: [String] { text.split(separator: " ").map { String($0) } }

        func username(on index: Int) -> String? {
            guard index < parameters.count else { return nil }
            let raw = parameters[index]
            if raw.hasPrefix("<@") && raw.hasSuffix(">") && raw.index(of: "|") != nil {
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

        func userId(on index: Int) -> String? {
            guard index < parameters.count else { return nil }
            let raw = parameters[index]
            if raw.hasPrefix("<@") && raw.hasSuffix(">") && raw.index(of: "|") != nil {
                let content = raw.replacingOccurrences(of: "<@", with: "")
                                   .replacingOccurrences(of: ">", with: "")
                let subParams = content.split(separator: "|").map { String($0) }
                guard subParams.count == 2 else { return nil }
                return subParams[0]
            } else{
                return nil
            }
        }

        func parameter(on index: Int) -> String? {
            guard index < parameters.count else { return nil }
            return parameters[index]
        }

    }

}
