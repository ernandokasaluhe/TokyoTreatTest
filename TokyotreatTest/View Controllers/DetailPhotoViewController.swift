//
//  DetailPhotoViewController.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 20/01/22.
//

import UIKit
import Kingfisher

class DetailPhotoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: PhotoViewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        if let urls = URL(string: viewModel.imageURL) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: urls,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        self.imageView.image = nil
                    }
                }
        }
    }
}

extension DetailPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                
                let confitionTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (confitionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
