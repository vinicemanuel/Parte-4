//
//  ReserveViewController.swift
//  Parte-4
//
//  Created by Vinicius Emanuel on 06/04/21.
//

import UIKit
import Nuke

fileprivate enum Section {
    case Main
}

class ReserveViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Livro>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configCollectionView()
    }
    
    private func configCollectionView() {
        let nib = UINib(nibName: LivroCell.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: LivroCell.reuseIdentifier)
        self.collectionView.collectionViewLayout = self.getCollectionViewLayout()
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, Livro>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, book) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LivroCell.reuseIdentifier, for: indexPath) as! LivroCell

            let livro = Biblioteca.shared.livros[indexPath.row]
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
            
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Livro>()
        snapshot.appendSections([.Main])
        snapshot.appendItems(Biblioteca.shared.livros)
        self.dataSource.apply(snapshot,animatingDifferences: true)
    }
    
    private func getCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let goup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: goup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
