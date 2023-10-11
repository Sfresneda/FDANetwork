//
//  Date.swift
//
//  Created by Sergio Fresneda on 11/10/23.
//

import Foundation

extension Date {
    /// Returns a string with the current date formatted as "yyyy-MM-dd HH:mm:ss:SSS"
    var completeCurrentTimeFormattedString: String {
        let calender = Calendar.current
        let components = calender
            .dateComponents([.year,
                             .month,
                             .day,
                             .hour,
                             .minute,
                             .second,
                             .nanosecond],
                            from: self)

        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let nanoSecond = components.nanosecond

        let today_string = "\(String(year!))-\(String(month!))-\(String(day!))  \(String(hour!)):\(String(minute!)):\(String(second!)):\(String(nanoSecond!))"

        return today_string
    }
}
