//
//  PropertyTableViewCell.swift
//  Villa
//
//  Created by McTavish Wang on 16/1/2.
//  Copyright © 2016年 Luohan. All rights reserved.
//

import UIKit

class PropertyCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bedrooms: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        statusView.layer.masksToBounds = true
        statusView.layer.cornerRadius = 10
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
