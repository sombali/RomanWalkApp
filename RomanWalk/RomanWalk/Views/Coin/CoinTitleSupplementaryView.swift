//
//  CoinTitleSupplementaryView.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 15..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import UIKit

class CoinTitleSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: CoinTitleSupplementaryView.self)

    let label = UILabel()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension CoinTitleSupplementaryView {
    func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
    }
}
