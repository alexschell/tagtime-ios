//
//  Note.swift
//  tagtime
//
//  Created by Alexander Schell on 3/12/23.s
//

struct Ping: Codable, Comparable {
    var title: Int
    var text: String
    
    static func <(lhs: Ping, rhs: Ping) -> Bool {
        return lhs.title < rhs.title
    }
    static func >(lhs: Ping, rhs: Ping) -> Bool {
        return lhs.title > rhs.title
    }
}
