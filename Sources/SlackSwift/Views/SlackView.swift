import Foundation

public typealias View = Slack.View

extension Slack {

    public final class View {

        public enum ViewType: String {
            case modal = "modal"
            case homeTabs = "home"
        }

        var type: ViewType

        var title: String

        var callbackId: String

        var blocks: [Block]

        var submit: String?

        private init(type: ViewType, title: String, callbackId: String, blocks: [Slack.Block]) {
            self.type = type
            self.title = title
            self.callbackId = callbackId
            self.blocks = blocks
        }

    }
}

extension Slack.View: Encodable {

    private enum CodingKeys: String, CodingKey {
        case type
        case callbackId = "callback_id"
        case title
        case blocks
        case submit
    }

    func verify() -> Bool {
        switch type {
        case .modal:
            let filtered = blocks.filter({
                let acceptables: [Slack.Block.BlockType] = [.actions, .context, .divider, .image, .input, .section]
                return acceptables.contains($0.type)
            })
            return blocks.count == filtered.count
        case .homeTabs:
            return true
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(title.plainText, forKey: .title)
        try container.encode(callbackId, forKey: .callbackId)
        try container.encode(blocks, forKey: .blocks)
        try container.encodeIfPresent(submit?.plainText, forKey: .submit)
    }

}

extension Slack.View {

    public static func modal(title: String, callbackId: String = UUID().uuidString, blocks: [Slack.Block], submit: String?) -> Slack.View {
        let view = Slack.View(type: .modal, title: title, callbackId: callbackId, blocks: blocks)
        view.submit = submit
        return view
    }

}
