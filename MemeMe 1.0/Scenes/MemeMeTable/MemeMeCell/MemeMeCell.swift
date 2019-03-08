//
//  MemeMeCell.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 08/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import UIKit

class MemeMeCell: UITableViewCell {
    
    @IBOutlet weak var imageMeme: UIImageView!
    @IBOutlet weak var labelMeme: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
