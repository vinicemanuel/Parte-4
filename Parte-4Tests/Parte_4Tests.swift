//
//  Parte_4Tests.swift
//  Parte-4Tests
//
//  Created by Vinicius Emanuel on 12/04/21.
//

import XCTest
@testable import Parte_4

class Parte_4Tests: XCTestCase {
    
    func testCategoriesIsUnique() {
        let categoires = Biblioteca.shared.categorias
        let categoriesSet: Set<String> = Set<String>(categoires)
        
        XCTAssertEqual(categoires.count, categoriesSet.count)
    }
    
    func testBookCategories() {
        let booksByCategories = Biblioteca.shared.livrosPorCategoria
        
        booksByCategories.forEach { (category) in
            let containsCategory = Biblioteca.shared.categorias.contains(category.nome)
            XCTAssertTrue(containsCategory, "don't contains category '\(category.nome)'")
            
            category.livros.forEach { (book) in
                let containsBook = Biblioteca.shared.livros.contains(book)
                XCTAssertTrue(containsBook, "don't contains book '\(book.title)'")
            }
        }
        
        XCTAssertNotEqual(booksByCategories.count, 0)
    }
}
