import Vapor

public typealias ShortcutPayload = Slack.ShortcutPayload

extension Slack {

    public struct ShortcutPayload: Content {

        var token: String

        var type: String

        var callback_id: String

        var trigger_id: String

        var responseUrl: URL

        var user: Slack.User

        var channel: Slack.Channel?

        var team: Slack.Team?

    }

}
