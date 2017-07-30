//
//  PlaceTableViewCell.swift
//  BlueMap
//
//  Created by Vinh on 7/2/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import UIKit
import AlamofireImage

class PlaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeImageView   : UIImageView!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var addressLabel     : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func adjustView(place :PlaceModel){
        
        placeImageView.af_setImage(
            withURL :URL(string: API.BASE_URL + place.thumb)!,
            placeholderImage: nil,
            filter: nil,
            imageTransition: .crossDissolve(0.5),
            completion: { response in
                //                print(response.result.value as Any)
                //                print(response.result.error as Any)
        })
        
        titleLabel.textColor        = COLOR.MAIN
        titleLabel.width            = self.width - titleLabel.left
        titleLabel.text             = place.title
        
        addressLabel.width          = self.width - titleLabel.left
        addressLabel.text           = place.address
    }    
}
