import Foundation

public typealias BlockElement = Slack.BlockElement

extension Slack {

    public final class BlockElement {

        public enum ElementType: String {
            case button
            case checkboxes
            case datePicker = "datepicker"
            case image
            case text
            case multiStaticSelect = "multi_static_select"
            case multiExternalSelect = "multi_external_select"
            case multiUserSelect = "multi_users_select"
            case multiConversationSelect = "multi_conversations_select"
            case multiChannelSelect = "multi_channels_select"
            case overflowMenu
            case plainTextInput = "plain_text_input"
            case radioButtonGroup
            case selectMenus
        }

        public enum ButtonStyle: String {
            case `default` = "default"
            case primary
            case danger
        }

        private(set) var type: ElementType

        fileprivate var text: Text?

        fileprivate var actionId: String?

        fileprivate var placeholder: String?

        fileprivate var initialValue: String?

        fileprivate var multiline: Bool?

        fileprivate var minLength: Int?

        fileprivate var maxLength: Int?

        fileprivate var url: String?

        fileprivate var value: String?

        fileprivate var style: ButtonStyle?

        fileprivate var confirm: Confirm?

        fileprivate var options: [Option]?

        fileprivate var initialOptions: [Option]?

        fileprivate var imageUrl: String?

        fileprivate var altText: String?

        fileprivate init(type: ElementType) {
            self.type = type
        }

    }
}

extension Slack.BlockElement: Encodable {

    private enum CodingKeys: String, CodingKey {
        case type
        case text
        case actionId = "action_id"
        case url
        case value
        case style
        case confirm
        case placeholder
        case initialValue = "initial_value"
        case multiline
        case minLength = "min_length"
        case maxLength = "max_length"
        case imageUrl = "image_url"
        case altText = "alt_text"
    }

    public func encode(to encoder: Encoder) throws {
        switch type {
        case .text:
            guard let text = text else { return }
            try text.encode(to: encoder)
        default:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type.rawValue, forKey: .type)
            try container.encodeIfPresent(text, forKey: .text)
            try container.encodeIfPresent(actionId, forKey: .actionId)
            try container.encodeIfPresent(url, forKey: .url)
            try container.encodeIfPresent(value, forKey: .value)
            try container.encodeIfPresent(style?.rawValue, forKey: .style)
            try container.encodeIfPresent(confirm, forKey: .confirm)
            try container.encodeIfPresent(placeholder?.plainText, forKey: .placeholder)
            try container.encodeIfPresent(initialValue, forKey: .initialValue)
            try container.encodeIfPresent(multiline, forKey: .multiline)
            try container.encodeIfPresent(minLength, forKey: .minLength)
            try container.encodeIfPresent(maxLength, forKey: .maxLength)
            try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
            try container.encodeIfPresent(altText, forKey: .altText)
        }

    }

}

extension Slack.BlockElement {

    static public func text(text: Text) -> Slack.BlockElement {
        let element = BlockElement(type: .text)
        element.text = text
        return element
    }

    static public func button(actionId: String,
                              text: String,
                              url: String? = nil,
                              value: String? = nil,
                              style: ButtonStyle? = nil,
                              confirm: Confirm? = nil) -> Slack.BlockElement {
        let element = BlockElement(type: .button)
        element.actionId = actionId
        element.text = text.plainText
        element.url = url
        element.value = value
        element.style = style
        element.confirm = confirm
        return element
    }

    static public func checkBoxes(actionId: String,
                                   options: [Option],
                                   initialOptions: [Option]? = nil,
                                   confirm: Confirm? = nil) -> Slack.BlockElement {
        let element = BlockElement(type: .checkboxes)
        element.actionId = actionId
        element.options = options
        element.initialOptions = initialOptions
        element.confirm = confirm
        return element
    }

    static public func datePicker(actionId: String,
                                  placeholder: String? = nil,
                                  initialValue: String? = nil,
                                  confirm: Confirm? = nil) -> Slack.BlockElement {
        let element = BlockElement(type: .datePicker)
        element.actionId = actionId
        element.placeholder = placeholder
        element.initialValue = initialValue
        element.confirm = confirm
        return element
    }

    static public func image(imageUrl: String, altText: String) -> Slack.BlockElement {
        let element = BlockElement(type: .image)
        element.imageUrl = imageUrl
        element.altText = altText
        return element
    }

    static public func plainTextInput(actionId: String,
                                      placeholder: String? = nil,
                                      initialValue: String? = nil,
                                      multiline: Bool? = nil,
                                      minLength: Int? = nil,
                                      maxLength: Int? = nil) -> Slack.BlockElement {
        let element = BlockElement(type: .plainTextInput)
        element.actionId = actionId
        element.placeholder = placeholder
        element.initialValue = initialValue
        element.multiline = multiline
        element.minLength = minLength
        element.maxLength = maxLength
        return element
    }

    private func verify() -> Bool {
        switch type {
        case .text:
            guard text != nil else { return false }
            return true
        case .button:
            guard actionId != nil, text != nil else { return false }
            return true
        case .checkboxes:
            guard let options = options, options.count > 0 else { return false }
            if let initialOptions = initialOptions {
                return initialOptions.filter({ options.contains($0) }).count == initialOptions.count
            } else {
                return true
            }
        case .datePicker:
            guard actionId != nil else { return false }
            return true
        case .image:
            guard imageUrl != nil, altText != nil else { return false }
            return true
        case .plainTextInput:
            guard actionId != nil else { return false }
            return true
        default:
            return false
        }
    }
}
