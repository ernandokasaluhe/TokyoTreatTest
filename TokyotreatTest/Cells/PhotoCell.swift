//
//  PhotoCell.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 19/01/22.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    func configure(viewModel: PhotoViewViewModel) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: viewModel.imageURL))
        labelName.text = viewModel.name
        labelDesc.text = viewModel.altDesc
    }
    
}
