//
//  Livro.swift
//  Parte-4
//
//  Created by Vinicius Emanuel on 01/04/21.
//

import Foundation

struct Livro: Codable {
    var title: String
    var isbn: String?
    var pageCount: Int
    var thumbnailUrl: URL?
    var shortDescription: String?
    var longDescription: String?
    var authors: [String]
    var categories: [String]
    var publishedDate: Date?
    var quantity: Int
}

extension Livro {
    var canReserve: Bool {
        get {
            return quantity > 0
        }
    }
}

extension Livro: Hashable {

}
