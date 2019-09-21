//
//  CIRoundedImageView.swift
//  searchBar
//
//  Created by Abdalla on 9/22/19.
//  Copyright © 2019 edu.data. All rights reserved.
//

import Foundation
import UIKit

class CIRoundedImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        
        self.layoutIfNeeded()
        layer.cornerRadius = self.frame.height / 6.0
        layer.masksToBounds = true
        layer.borderWidth = 4.0
        layer.borderColor = UIColor.white.cgColor
    }
}
