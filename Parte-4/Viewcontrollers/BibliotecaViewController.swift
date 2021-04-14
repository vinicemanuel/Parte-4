//
//  BibliotecaViewController.swift
//  Parte-4
//
//  Created by Vinicius Emanuel on 01/04/21.
//

import UIKit
import Nuke

class BibliotecaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var searchController: UISearchController!
    private let preheater = ImagePrefetcher()
    private var categories = Biblioteca.shared.livrosPorCategoria
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let nib = UINib(nibName: LivroCell.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: LivroCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Books"
        self.navigationItem.titleView = searchController.searchBar
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? BookDetailViewController, let index = sender as? Int {
            viewController.bookIndex = index
        }
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = categories[indexPath.section].livros[indexPath.row]
        guard let bookIndex: Int = Biblioteca.shared.livros.lastIndex(where: {$0.title == book.title}) else { return }
        
        self.performSegue(withIdentifier: "fromBibliotecaViewControllerToBookDetailViewController", sender: bookIndex)
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].livros.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LivroCell.reuseIdentifier, for: indexPath) as! LivroCell
        
        let livro = categories[indexPath.section].livros[indexPath.row]
        cell.titleLabel.text = livro.title
        
        if let date = livro.publishedDate {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd/MMM/yyyy"
            cell.dateLabel.text = "\(dateFormater.string(from: date))"
        }
        
        if let url = livro.thumbnailUrl {
            
            let options = ImageLoadingOptions(
                placeholder: UIImage(systemName: "book"),
                transition: .none
            )
            Nuke.loadImage(with: url, options: options, into: cell.imageView)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeader.reuseIdentifier, for: indexPath) as! CollectionHeader
        
        header.titleLabel.text = categories[indexPath.section].nome
        
        return header
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let columns: CGFloat = 3
        let verticalInset: CGFloat = 16
        let spacing: CGFloat = 10
        let availableWidth = screenWidth - (verticalInset * 2) - (spacing * (columns - 1))
        let cellWidth = floor(availableWidth / columns)
        let cellHeight: CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    //MARK: - UICollectionViewDataSourcePrefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { indexPath in
            Biblioteca.shared.livros[indexPath.row].thumbnailUrl
        }
        preheater.startPrefetching(with: urls)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        let urls = indexPaths.compactMap { indexPath in
            Biblioteca.shared.livros[indexPath.row].thumbnailUrl
        }
        
        preheater.stopPrefetching(with: urls)
    }
}

extension BibliotecaViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.categories = Biblioteca.shared.getLivrosPorCategoria(filterByTitle: text)
        self.collectionView.reloadData()
    }
}

