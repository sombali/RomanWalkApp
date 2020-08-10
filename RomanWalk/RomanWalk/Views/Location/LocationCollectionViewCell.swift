//
//  LocationCollectionViewCell.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: LocationCollectionViewCell.self)
    
    let labelStackView = UIStackView()
    let imageView = UIImageView()
    let gradientView = GradientView()
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension LocationCollectionViewCell {
    func configure() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        labelStackView.axis = .vertical
        labelStackView.distribution = .equalSpacing
        labelStackView.alignment = .leading
        labelStackView.spacing = 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(locationLabel)
        
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        locationLabel.font = UIFont.preferredFont(forTextStyle: .body)
        locationLabel.adjustsFontForContentSizeCategory = true
        locationLabel.textColor = .white
        
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: imageView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 5),
            labelStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            labelStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        ])
        
    }
}
