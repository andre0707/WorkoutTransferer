//
//  Date.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import Foundation

/// Member access to certain dates relative to `self`
extension Date {
    
    /// The start of the day for `self`
    var startOfTheDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// The end of the day for `self`
    var endOfTheDay: Date {
        let components = DateComponents(day: 1, second: -1)
        return Calendar.current.date(byAdding: components, to: startOfTheDay)!
    }
    
    /// The start of the month for `self`
    var startOfTheMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }
    
    /// The end of the month for `self`
    var endOfTheMonth: Date {
        let components = DateComponents(month: 1, second: -1)
        return Calendar.current.date(byAdding: components, to: startOfTheMonth)!
    }
    
    /// The start of the year for `self`
    var startOfTheYear: Date {
        let components = Calendar.current.dateComponents([.year], from: self)
        
        return Calendar.current.date(from: components)!
    }
    
    /// The end of the year for `self`
    var endOfTheYear: Date {
        let components = DateComponents(year: 1, second: -1)
        return Calendar.current.date(byAdding: components, to: startOfTheYear)!
    }
    
    /// The start of the last month of `self`
    var startOfLastMonth: Date {
        let components = DateComponents(month: -1)
        return Calendar.current.date(byAdding: components, to: startOfTheMonth)!
    }
    
    /// The end of the last month of `self`
    var endOfLastMonth: Date {
        let components = DateComponents(second: -1)
        return Calendar.current.date(byAdding: components, to: startOfTheMonth)!
    }
    
    /// The start of the last year of `self`
    var startOfLastYear: Date {
        let components = DateComponents(year: -1)
        return Calendar.current.date(byAdding: components, to: startOfTheYear)!
    }
    
    /// The end of the last year of `self`
    var endOfLastYear: Date {
        let components = DateComponents(second: -1)
        return Calendar.current.date(byAdding: components, to: startOfTheYear)!
    }
}
 
/// Static access to certain dates
extension Date {
    
    /// The start of today
    static var startOfToday: Date {
        Date().startOfTheDay
    }
    
    /// The end of today
    static var endOfToday: Date {
        Date().endOfTheDay
    }
    
    /// The start of this month
    static var startOfThisMonth: Date {
        Date().startOfTheMonth
    }
    
    /// The end of this month
    static var endOfThisMonth: Date {
        Date().endOfTheMonth
    }
    
    /// The start of this year
    static var startOfThisYeaer: Date {
        Date().startOfTheYear
    }
    
    /// The end of the year for `self`
    static var endOfThisYear: Date {
        Date().endOfTheYear
    }
    
    /// The start of the last month of `self`
    static var startOfLastMonth: Date {
        Date().startOfLastMonth
    }
    
    /// The end of the last month of `self`
    static var endOfLastMonth: Date {
        Date().endOfLastMonth
    }
    
    /// The start of the last year of `self`
    static var startOfLastYear: Date {
        Date().startOfLastYear
    }
    
    /// The end of the last year of `self`
    static var endOfLastYear: Date {
        Date().endOfLastYear
    }
}
