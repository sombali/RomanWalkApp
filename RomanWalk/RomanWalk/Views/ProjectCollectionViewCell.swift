//
//  ProjectCollectionViewCell.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 03..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class ProjectCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ProjectCollectionViewCell.self)
    
    let stackView = UIStackView()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ProjectCollectionViewCell {
    func configure() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 2
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        contentView.addSubview(nameLabel)
        
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.textColor = .white
        
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.placeholderText
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(greaterThanOrEqualTo: imageView.leftAnchor),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor)
        ])
    }
}
