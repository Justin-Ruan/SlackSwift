import Foundation

public typealias Block = Slack.Block

extension Slack {

    public final class Block {

        public enum BlockType: String {
            case actions
            case context
            case divider
            case file
            case image
            case input
            case section
        }

        private(set) var type: BlockType

        private(set) var blockId: String?

        private var elements: [BlockElement]?

        private var element: BlockElement?

        private var externalId: String?

        private var source: String?

        private var imageUrl: String?

        private var altText: String?

        private var title: Text?

        private var label: String?

        private var hint: String?

        private var optional: Bool?

        private var text: Text?

        private var fields: [Text]?

        private var accessory: BlockElement?

        private init(type: BlockType, blockId: String?) {
            self.type = type
            self.blockId = blockId
        }

    }
}

extension Slack.Block: Encodable {

    private enum CodingKeys: String, CodingKey {
        case type
        case blockId = "block_id"
        case element
        case elements
        case label
        case hint
        case optional
        case text
        case fields
    }

    public func encode(to encoder: Encoder) throws {
        guard verify() else { throw SlackSwiftError.blockVerifyFailed }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.rawValue, forKey: .type)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(blockId, forKey: .blockId)
        try container.encodeIfPresent(label?.plainText, forKey: .label)
        try container.encodeIfPresent(element, forKey: .element)
        try container.encodeIfPresent(elements, forKey: .elements)
        try container.encodeIfPresent(hint, forKey: .hint)
        try container.encodeIfPresent(optional, forKey: .optional)
        try container.encodeIfPresent(fields, forKey: .fields)
    }

}


extension Slack.Block {

    static public func actionsBlock(blockId: String? = nil, elements: [Slack.BlockElement]) -> Slack.Block {
        let block = Slack.Block(type: .actions, blockId: blockId)
        block.elements = elements
        return block
    }

    static public func contextBlock(blockId: String? = nil, elements: [Slack.BlockElement]) -> Slack.Block {
        let block = Slack.Block(type: .context, blockId: blockId)
        block.elements = elements
        return block
    }

    static public func dividerBlock(blockId: String? = nil) -> Slack.Block {
        let block = Slack.Block(type: .divider, blockId: blockId)
        return block
    }

    static public func fileBlock(blockId: String? = nil, externalId: String, source: String) -> Slack.Block {
        let block = Slack.Block(type: .file, blockId: blockId)
        block.externalId = externalId
        block.source = source
        return block
    }

    static public func imageBlock(blockId: String? = nil, title: Slack.Text? = nil, imageUrl: String, altText: String) -> Slack.Block {
        let block = Slack.Block(type: .image, blockId: blockId)
        block.title = title
        block.imageUrl = imageUrl
        block.altText = altText
        return block
    }

    static public func inputBlock(blockId: String? = nil,
                                  label: String,
                                  element: Slack.BlockElement,
                                  hint: String? = nil,
                                  optional: Bool? = nil) -> Slack.Block {
        let block = Slack.Block(type: .input, blockId: blockId)
        block.label = label
        block.element = element
        block.hint = hint
        block.optional = optional
        return block
    }

    static public func sectionBlock(blockId: String? = nil, text: Slack.Text? = nil, fields: [Slack.Text]? = nil, accessory: Slack.BlockElement? = nil) -> Slack.Block {
        let block = Slack.Block(type: .section, blockId: blockId)
        block.text = text
        block.fields = fields
        return block
    }

    private func verify() -> Bool {
        switch type {
        case .actions:
            guard let elements = elements else { return false }
            let filtered = elements.filter({
                let acceptables: [BlockElement.ElementType] = [.button, .selectMenus, .overflowMenu, .datePicker]
                return acceptables.contains($0.type)
            })
            return elements.count == filtered.count
        case .context:
            guard let elements = elements else { return false }
            let filtered = elements.filter({
                let acceptables: [BlockElement.ElementType] = [.text, .image]
                return acceptables.contains($0.type)
            })
            return elements.count == filtered.count && filtered.count <= 10
        case .divider:
            return true
        case .file:
            return externalId != nil && source != nil
        case .image:
            return imageUrl != nil && altText != nil
        case .input:
            let acceptables: [BlockElement.ElementType] = [
                .plainTextInput, .selectMenus,
                .multiStaticSelect, .multiExternalSelect, .multiUserSelect, .multiConversationSelect, .multiChannelSelect,
                .datePicker
            ]
            guard label != nil, let element = element, acceptables.contains(element.type) else { return false }
            return true
        case .section:
            guard text != nil || fields != nil else { return false }
            return true
        }
    }
}
