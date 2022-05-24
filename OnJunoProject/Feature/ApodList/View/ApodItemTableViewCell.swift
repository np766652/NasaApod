//
//  ApodItemTableViewCell.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import UIKit
import SDWebImage

protocol ApodItemTableViewCellDelegate: AnyObject {
    func onLayoutChangeNeeded()
    func thumbnailTappedAt(_ index: Int)
}

class ApodItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    weak var delegate: ApodItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.addShadow()
        self.apodImageView.addShadow()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(thumbnailtapped))
        self.apodImageView.addGestureRecognizer(tapRecognizer)
        self.apodImageView.isUserInteractionEnabled = true
    }
    
    func setupView(delegate: ApodItemTableViewCellDelegate, index: Int, apodResponse: ApodResponse) {
        self.delegate = delegate
        self.tag = index
        
        self.dateLabel.text = apodResponse.date
        self.descriptionLabel.text = apodResponse.description
        self.titleLabel.text = apodResponse.title
        self.mediaTypeLabel.text = apodResponse.mediaType
        self.loadImage(urlString: apodResponse.url)
        
        if let _mediaType = apodResponse.mediaType,
            let mediaType = MediaType(rawValue: _mediaType) {
            switch mediaType {
            case .image:
                self.loadImage(urlString: apodResponse.url)
            case .video:
                break
            }
        }
    }
    
    func loadImage(urlString: String?) {
        guard let urlString = urlString,
                let imageURL = URL(string: urlString) else {
            self.apodImageView.image = nil
            return
        }
        let transition = SDWebImageTransition.fade
        transition.prepares = { (view, _, _, _, _) in
            view.transform = .init(rotationAngle: .pi)
        }
        transition.animations = { (view, _) in
            view.transform = .identity
        }
        self.apodImageView.sd_imageTransition = transition
        self.apodImageView.sd_setImage(with: imageURL, placeholderImage: ImageConstant.placeholder.image) { [weak self] (_,_,_,_) in
            guard let self = self else {return}
            self.delegate?.onLayoutChangeNeeded()
        }
    }
    
    @objc func thumbnailtapped() {
        self.delegate?.thumbnailTappedAt(self.tag)
    }

}





