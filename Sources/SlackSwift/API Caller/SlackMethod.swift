import Vapor

extension Slack {

    public enum SlackMethod {

        case view(subMethod: ViewSubMethod)

        var route: String {
            var retVal = "https://slack.com/api/"
            switch self {
            case .view(let subMethod):
                retVal += subMethod.path
            }
            return retVal
        }
    }

}

