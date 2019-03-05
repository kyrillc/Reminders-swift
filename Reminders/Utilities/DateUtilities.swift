//
//  DateUtilities.swift
//  Reminders
//
//  Created by Kyrill Cousson on 04/03/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import Foundation

func nearFutureDate() -> Date {
    return Date(timeIntervalSinceNow: 5 * 60).ceil(precision: 5*60)
}

extension Date {
    
    public func toFormattedString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.short
        return dateformatter.string(from:self)
    }
    
    public func round(precision: TimeInterval) -> Date {
        return round(precision: precision, rule: .toNearestOrAwayFromZero)
    }
    
    public func ceil(precision: TimeInterval) -> Date {
        return round(precision: precision, rule: .up)
    }
    
    public func floor(precision: TimeInterval) -> Date {
        return round(precision: precision, rule: .down)
    }
    
    private func round(precision: TimeInterval, rule: FloatingPointRoundingRule) -> Date {
        let seconds = (self.timeIntervalSinceReferenceDate / precision).rounded(rule) *  precision;
        return Date(timeIntervalSinceReferenceDate: seconds)
    }
}
