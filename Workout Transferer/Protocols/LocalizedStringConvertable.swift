//
//  LocalizedStringConvertable.swift
//  Workout Transferer
//
//  Created by Andre Albach on 20.09.24.
//


/// A helper protocol for objects which can be converted into localized strings
protocol LocalizedStringConvertable {
    var description: String { get }
}


extension String: LocalizedStringConvertable {}
