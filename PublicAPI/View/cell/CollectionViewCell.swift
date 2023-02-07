//
//  CollectionViewCell.swift
//  PublicAPI
//
//  Created by Unsal Oner on 7.02.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var apiLabel: UILabel!
    
    
    @IBOutlet weak var isHttpsLabel: UILabel!
    
    @IBOutlet weak var linkLabel: UILabel!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
