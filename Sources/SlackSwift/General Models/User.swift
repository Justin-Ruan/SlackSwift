import Vapor

public typealias User = Slack.User

extension Slack {

    public struct User: Content {

        public struct Profile: Content {
            var real_name: String

            var display_name: String
        }

        var id: String

        var name: String

        var profile: Profile?

        var displayName: String? {
            return profile?.display_name
        }

    }

}
