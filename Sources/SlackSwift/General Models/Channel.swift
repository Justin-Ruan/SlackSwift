import Vapor

public typealias Channel = Slack.Channel

extension Slack {

    public struct Channel: Content {

        var id: String

        var name: String

    }

}
