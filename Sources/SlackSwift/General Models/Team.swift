import Vapor

public typealias Team = Slack.Team

extension Slack {

    public struct Team: Content {

        var id: String

        var domain: String

    }

}
