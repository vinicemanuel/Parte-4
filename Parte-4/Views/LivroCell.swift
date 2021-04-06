//
//  LivroCell.swift
//  Parte-4
//
//  Created by Vinicius Emanuel on 01/04/21.
//

import UIKit
import Nuke

class LivroCell: UICollectionViewCell {
    
    static let reuseIdentifier = "BookCollectionViewCell"
    static let nibName = "LivroCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
