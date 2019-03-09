//
//  UICollectionView+ext.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 08/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func deselectRows(_ animated: Bool = false) {
        indexPathsForSelectedItems?.forEach {
            deselectItem(at: $0, animated: animated)
        }
    }
    
    func registerCell(_ cellClass: UICollectionViewCell.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func registerCellWithNib(_ cellClass: UICollectionViewCell.Type) {
        let nib = UINib(nibName: String(describing: cellClass.self), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: String(describing: cellClass.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, index: Int) -> T {
        return dequeueReusableCell(type: type, indexPath: IndexPath(row: index, section: 0))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T ?? T()
    }
    
}
