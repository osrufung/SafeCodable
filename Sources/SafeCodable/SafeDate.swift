//
//  File.swift
//  
//
//  Created by Oswaldo Rubio on 17/01/2021.
//

import Foundation

extension Date {
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static func getDateFromString(_ dateString: String, includeFractions: Bool = false) -> Date? {
        let formatter = ISO8601DateFormatter()
        var options:ISO8601DateFormatter.Options = [.withInternetDateTime,
                                   .withDashSeparatorInDate,
                                   .withFullDate,
                                   .withColonSeparatorInTimeZone]
        if includeFractions {
            options.insert(.withFractionalSeconds)
        }
        formatter.formatOptions = options
        guard let date = formatter.date(from: dateString) else {
            return shortFormatter.date(from: dateString)
        }
        return date
    }
}
public struct IsoDateError: Error {}
public extension JSONDecoder.DateDecodingStrategy {
    static func iso8601(extended: Bool = true) -> JSONDecoder.DateDecodingStrategy {
        return .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            guard
                let date = Date.getDateFromString(dateStr)
            else {
                if extended, let date = Date.getDateFromString(dateStr, includeFractions: true) {
                    return date
                }
                throw IsoDateError()
            }
            return date
        }
    }
    
}
