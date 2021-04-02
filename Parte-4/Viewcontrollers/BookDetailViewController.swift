//
//  BookDetailViewController.swift
//  Parte-4
//
//  Created by Vinicius Emanuel on 02/04/21.
//

import Foundation
import UIKit
import Nuke

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookDate: UILabel!
    @IBOutlet weak var bookIsbn: UILabel!
    @IBOutlet weak var bookNumbers: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var reserveButton: UIButton!
    
    var book: Livro!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView(book: self.book)
    }
    
    func configView(book: Livro) {
        
        self.bookTitle.text = "Titulo: \(book.title)"
        self.bookIsbn.text = "isbn: \(book.isbn ?? "")"
        self.bookNumbers.text = "Quantidade: \(book.quantity)"
        self.bookDescription.text = book.shortDescription
        
        if let url = book.thumbnailUrl {
            let options = ImageLoadingOptions(
                placeholder: UIImage(systemName: "book"),
                transition: .none
            )
            Nuke.loadImage(with: url, options: options, into: self.bookImage)
        }
        
        if let date = book.publishedDate {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd 'de' MMM 'de' yyyy"
            self.bookDate.text = "Publicado em: \(dateFormater.string(from: date))"
        }
        
        if !book.canReserve {
            self.reserveButton.isEnabled = false
            self.reserveButton.alpha = 0.3
        } else {
            self.reserveButton.isEnabled = true
            self.reserveButton.alpha = 1
        }
    }
    
    @IBAction func reserveButtonTaped(_ sender: Any) {
        
    }
}
