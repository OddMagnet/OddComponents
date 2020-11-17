//
//  User.swift
//  OddComponents
//
//  Created by Michael Brünen on 17.11.20.
//

import Foundation

/// This is only used as example data for the FilteringList component
struct User: Decodable, Identifiable {
    let id: UUID
    let name: String
    let age: Int
    let birthplace: String
}

let userSampleData = [
    User(id: UUID(), name: "James Hetfield",    age: 57, birthplace: "California, U.S"),
    User(id: UUID(), name: "Lars Ulrich",       age: 56, birthplace: "Gentofte, Denmark"),
    User(id: UUID(), name: "Kirk Hammett",      age: 57, birthplace: "California, U.S."),
    User(id: UUID(), name: "Robert Trujillo",   age: 56, birthplace: "California, U.S."),
    User(id: UUID(), name: "Dave Mustaine",     age: 59, birthplace: "California, U.S."),
    User(id: UUID(), name: "Ron McGovney",      age: 58, birthplace: "California, U.S."),
    User(id: UUID(), name: "Jason Newsted",     age: 57, birthplace: "Michigan, U.S."),
]
