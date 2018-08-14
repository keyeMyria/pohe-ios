//
//  DateFormat.swift
//  pohe-ios
//
import Foundation
public extension Date {
    static let ISO8601Formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    init?(fromISO8601 string: String) {
        guard let date = Date.ISO8601Formatter.date(from: string) else {
            return nil
        }
        self = date
    }
    init?(fromIOS8601_2 string: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        self = date
    }
    
    static func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)! as Calendar
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
    static func human(date: Date) -> String {
        var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let today = Calendar(identifier: .gregorian).date(from: comp)!
        if (date > today) {
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "HH:mm a"
            return dayTimePeriodFormatter.string(from: date)
        } else {
            return Date.stringFromDate(date: date, format: "yyyy-MM-dd")
        }
    }
}
