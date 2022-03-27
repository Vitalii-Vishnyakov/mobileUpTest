//
//  PhotoItemCollectionViewCell.swift
//  mobileUpTest
//
//  Created by Виталий on 26.03.2022.
//

import UIKit

class PhotoItemCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
      
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}
