import Vapor

public typealias ShortcutPayload = Slack.ShortcutPayload

extension Slack {

    public struct ShortcutPayload: Content {

        internal(set) public var token: String

        internal(set) public var type: String

        internal(set) public var callback_id: String

        internal(set) public var trigger_id: String

        internal(set) public var responseUrl: URL

        internal(set) public var user: Slack.User

        internal(set) public var channel: Slack.Channel?

        internal(set) public var team: Slack.Team?

    }

}
