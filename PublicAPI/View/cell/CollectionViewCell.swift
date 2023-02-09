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
//        Label tıklanabilir
        linkLabel.isUserInteractionEnabled = true
//        Label'ı altı çizili yap.
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineText = NSAttributedString(string: linkLabel.text!, attributes: underlineAttribute)
        linkLabel.attributedText = underlineText
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        linkLabel.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(){
        guard let url = URL(string: linkLabel.text!) else {return}
        UIApplication.shared.open(url,options: [:],completionHandler: nil)
    }
}
