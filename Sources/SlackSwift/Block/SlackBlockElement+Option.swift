import Foundation

extension Slack.BlockElement {

    public final class Option {

        private var text: String

        private var value: String

        var description: String?

        var url: String?

        init(text: String, value: String, description: String? = nil, url: String? = nil) {
            self.text = text
            self.value = value
            self.description = description
            self.url = url
        }

    }

}

extension Slack.BlockElement.Option: Equatable {

    public static func == (lhs: Slack.BlockElement.Option, rhs: Slack.BlockElement.Option) -> Bool {
        return lhs.value == rhs.value
    }

}

extension Slack.BlockElement.Option: Encodable {

    private enum CodingKeys: String, CodingKey {
        case text
        case value
        case description
        case url
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text.plainText, forKey: .text)
        try container.encode(value, forKey: .value)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(url, forKey: .url)
    }

}
