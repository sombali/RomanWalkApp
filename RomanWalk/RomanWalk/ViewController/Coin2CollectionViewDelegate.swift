//
//  Coin2CollectionViewDelegate.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 21..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import UIKit

class CoinCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    let numberOfItemsPerRow: CGFloat
    let interItemSpacing: CGFloat
    
    let sideSpacing = CGFloat(20.0)
  
    init(numberOfItemsPerRow: CGFloat, interItemSpacing: CGFloat) {
        self.numberOfItemsPerRow = numberOfItemsPerRow
        self.interItemSpacing = interItemSpacing
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = UIScreen.main.bounds.width
    
        if indexPath.section == 0 {
            return CGSize(width: maxWidth - (2 * sideSpacing), height: (maxWidth - (2 * sideSpacing)) / 2)
            } else {
            let totalSpacing = interItemSpacing * numberOfItemsPerRow + 40
            let itemWidth = (maxWidth - totalSpacing)/numberOfItemsPerRow
            print("ITT MEGHIVODIK")
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: sideSpacing, bottom: interItemSpacing/2, right: sideSpacing)
        } else {
            return UIEdgeInsets(top: interItemSpacing/2, left: sideSpacing, bottom: interItemSpacing/2, right: sideSpacing)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
}
