//
//  CoinStaticCollectionViewCell.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 15..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class CoinStaticCollectionViewCell: UICollectionViewCell {
        static let reuseIdentifier = String(describing: CoinStaticCollectionViewCell.self)
        
        let descriptionLabel = UILabel()
        let percentageLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
    }

extension CoinStaticCollectionViewCell {
    func configure() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(percentageLabel)
        
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        
        percentageLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        percentageLabel.adjustsFontForContentSizeCategory = true
        percentageLabel.textColor = .red
        percentageLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            percentageLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            percentageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            percentageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            percentageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
}
