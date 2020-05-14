import Foundation

public typealias Text = Slack.Text

extension Slack {

    final public class Text {

        public enum TextType: String {
            case plainText = "plain_text"
            case markDown = "mrkdwn"
        }

        var type: TextType

        var text: String

        var emoji: Bool?

        var verbatim: Bool?

        public init(type: TextType, text: String, emoji: Bool? = nil) {
            self.type = type
            self.text = text
            self.emoji = emoji
        }

    }
}

extension Slack.Text: Encodable {

    private enum CodingKeys: String, CodingKey {
        case type
        case text
        case emoji
        case verbatim
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(emoji, forKey: .emoji)
        try container.encodeIfPresent(verbatim, forKey: .verbatim)
    }
}

extension String {

    public var plainText: Slack.Text { Slack.Text(type: .plainText, text: self) }

}
