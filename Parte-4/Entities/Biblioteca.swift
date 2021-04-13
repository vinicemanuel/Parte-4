//
//  Biblioteca.swift
//  Parte-4
//
//  Created by Vinicius Emanuel on 01/04/21.
//

import Foundation

typealias Category = [(nome: String,livros: [Livro])]

class Biblioteca {
    static var shared = Biblioteca()
    private init() {}
    
    var livros: [Livro] = {
        let contents = try! Data(contentsOf: Bundle.main.url(forResource: "books", withExtension: "json")!)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let books = try! decoder.decode([Livro].self, from: contents)
        return books
    }()
    
    lazy private(set) var categorias: [String] = {
        var categoreis = self.livros.flatMap({$0.categories})
        categoreis.append("Outros")
        let categoriesSet: Set<String> = Set<String>(categoreis)
        return Array(categoriesSet).sorted()
    }()
    
    lazy private(set) var livrosPorCategoria: Category = {
        var result: Category = []
        var booksWithCategoires: [Livro] = []
        
        self.categorias.forEach { (categorie) in
            let books = self.livros.filter({$0.categories.contains(categorie)})
            if books.count > 0 {
                booksWithCategoires.append(contentsOf: books)
                result.append((categorie, books))
            }
        }
        
        let otherBooks = self.livros.difference(from: booksWithCategoires)
        if otherBooks.count > 0 {
            result.append(("Outros", otherBooks))
        }
        
        return result
    }()
}
