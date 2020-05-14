import Foundation

extension Slack.BlockElement {

    final public class Confirm {

        private enum CodingKeys: String, CodingKey {
            case title
            case text
            case confirm
            case deny
            case style
        }

        var title: String

        var text: Slack.Text

        var confirm: String

        var deny: String

        var style: ButtonStyle?

        init(title: String, text: Slack.Text, confirm: String, deny: String, style: Slack.BlockElement.ButtonStyle? = nil) {
            self.title = title
            self.text = text
            self.confirm = confirm
            self.deny = deny
            self.style = style
        }

    }

}

extension Slack.BlockElement.Confirm: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title.plainText, forKey: .title)
        try container.encode(text, forKey: .text)
        try container.encode(confirm.plainText, forKey: .confirm)
        try container.encode(deny.plainText, forKey: .deny)
        try container.encodeIfPresent(style?.rawValue, forKey: .style)
    }

}

