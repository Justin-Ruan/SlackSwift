import Vapor

public typealias SlackDirectResponse = Slack.DirectResponse

extension Slack {

    public final class DirectResponse {

        public enum ResponseType: String {
            case inChannel = "in_channel"
            case ephemeral = "ephemeral"
        }

        var type: ResponseType

        var text: String?

        var isMarkDown: Bool?

        var blocks: [Slack.Block]?

        init(type: ResponseType, text: String, isMarkDown: Bool? = nil, blocks: [Slack.Block]? = nil) {
            self.type = type
            self.text = text
            self.isMarkDown = isMarkDown

        }

        init(type: ResponseType, blocks: [Slack.Block]) {
            self.type = type
            self.blocks = blocks
        }

    }

}

extension Slack.DirectResponse: Content {

    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case text
        case isMarkDown = "mrkdwn"
        case blocks
    }

    public convenience init(from decoder: Decoder) throws {
        fatalError()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.rawValue, forKey: .responseType)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(isMarkDown, forKey: .isMarkDown)
        try container.encodeIfPresent(blocks, forKey: .blocks)
    }
}
