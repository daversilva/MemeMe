//
//  Meme.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 03/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

struct Meme {
    let top: String!
    let bottom: String!
    let original: UIImage!
    let meme: UIImage!
    let date = Date()
}

extension Meme: Equatable { }

func == (lhs: Meme, rhs: Meme) -> Bool {
    return lhs.date.timeIntervalSinceNow == rhs.date.timeIntervalSinceNow

}


extension Meme: IdentifiableType {
    typealias Identity = String
    
    var identity: Meme.Identity {
        return "\(String(describing: top))#\(String(describing: bottom))#\(String(describing: meme))#\(date.timeIntervalSinceNow)"
    }
}
