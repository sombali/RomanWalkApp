//
//  CoinCollectionViewCell.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 15..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import PureLayout

class CoinCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CoinCollectionViewCell.self)
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension CoinCollectionViewCell {
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
