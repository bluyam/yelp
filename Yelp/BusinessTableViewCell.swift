//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Kyle Wilson on 2/3/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var businessLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var kindLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var ratingImageView: UIImageView!
    
    var business: Business! {
        didSet {
            businessLabel.text = business.name
            safeSetImageWithURL(thumbImageView, imagePath: business.imageURL)
            kindLabel.text = business.categories
            addressLabel.text = business.address
            reviewLabel.text = "\(business.reviewCount!) Reviews"
            distanceLabel.text = business.distance
            ratingImageView.setImageWithURL(business.ratingImageURL!)
        }
    }
    
    func safeSetImageWithURL(imageView: UIImageView, imagePath: NSURL?) {
        if imagePath != nil {
            imageView.setImageWithURLRequest(NSURLRequest(URL: imagePath!), placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                    imageView.alpha = 0
                    imageView.image = image
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        imageView.alpha = 1
                    })
                }
                else {
                    imageView.image = image
                }
                }, failure: { (imageRequest, imageResponse, imageError) -> Void in
            })
        }
        else {
            // set placeholder
        }
    }

    override func awakeFromNib() {
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
