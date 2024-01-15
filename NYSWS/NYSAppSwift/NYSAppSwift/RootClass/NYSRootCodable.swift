//
//  NYSRootCodable.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/15.
//

import ExCodable

struct NYSRootCodable: Equatable {
    var ID: Int = 0
    var xid: String!
}

extension NYSRootCodable: ExCodable {
    
    static let keyMapping: [KeyMap<Self>] = [
        KeyMap(\.ID, to: "id"),
        KeyMap(\.xid, to: "nested.id")
    ]
    
    init(from decoder: Decoder) throws {
        try decode(from: decoder, with: Self.keyMapping)
    }
    
    func encode(to encoder: Encoder) throws {
        try encode(to: encoder, with: Self.keyMapping)
    }
    
}
