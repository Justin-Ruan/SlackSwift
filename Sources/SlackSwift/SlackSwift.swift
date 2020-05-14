import Foundation

public let SlackAPICaller = Slack.apiCaller

// Facade
public class Slack {

    static public var apiCaller = APICaller()

}
