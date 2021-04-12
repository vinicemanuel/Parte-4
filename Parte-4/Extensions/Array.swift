//
//  Array.swift
//  Parte-4
//
//  Created by Vinicius Emanuel on 12/04/21.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
