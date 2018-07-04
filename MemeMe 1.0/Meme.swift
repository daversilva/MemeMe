//
//  Meme.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 03/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let top: String!
    let bottom: String!
    let original: UIImage!
    let meme: UIImage!
}

enum TextFieldInit: String {
    case top = "TOP", bottom = "BOTTOM"
}
