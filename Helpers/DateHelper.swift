import Foundation

extension Date {
    static func isMidnight() -> Bool {
        let now = Date()
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
        return components.hour == 0 && components.minute == 0 && components.second == 0
    }
}
