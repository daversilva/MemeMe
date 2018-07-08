//
//  MemeTableViewCell.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 07/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageMeme: UIImageView!
    @IBOutlet weak var labelMeme: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
