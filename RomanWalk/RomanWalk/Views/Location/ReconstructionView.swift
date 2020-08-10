//
//  ReconstructionView.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import Foundation

public class ReconstructionView: UIView {
    
    fileprivate var imageSeparatorConstraint: NSLayoutConstraint!
    fileprivate var reconstuctedStoredFrame: CGRect!
    
    var backgroundImageView = UIImageView()
    var reconstructedImageView = UIImageView()
    var reconstructedWrapper = UIView()
    var selectorWrapper = UIView()
    var selector = UIView()

    lazy fileprivate var setupSeparatorAndStoreFrame: Void = {
        self.imageSeparatorConstraint.constant = frame.width / 2
        self.layoutIfNeeded()
        self.reconstuctedStoredFrame = reconstructedWrapper.frame
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        _ = setupSeparatorAndStoreFrame
    }
}

extension ReconstructionView {
    fileprivate func initialize() {
        setupViews()
        addViewsToSuperView()
        setupImageViews()
        activateConstraints()
        setupSelector()
        setupGestureRecognizers()
    }
    
    fileprivate func setupViews() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        reconstructedImageView.translatesAutoresizingMaskIntoConstraints = false
        reconstructedWrapper.translatesAutoresizingMaskIntoConstraints = false
        selectorWrapper.translatesAutoresizingMaskIntoConstraints = false
        selector.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.clipsToBounds = true
        reconstructedImageView.clipsToBounds = true
        reconstructedWrapper.clipsToBounds = true
        selectorWrapper.clipsToBounds = true
        selector.clipsToBounds = true
    }
    
    fileprivate func activateConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        imageSeparatorConstraint = reconstructedWrapper.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        NSLayoutConstraint.activate([
            reconstructedWrapper.topAnchor.constraint(equalTo: topAnchor),
            reconstructedWrapper.bottomAnchor.constraint(equalTo: bottomAnchor),
            reconstructedWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageSeparatorConstraint
        ])
        
        NSLayoutConstraint.activate([
            reconstructedImageView.topAnchor.constraint(equalTo: reconstructedWrapper.topAnchor),
            reconstructedImageView.bottomAnchor.constraint(equalTo: reconstructedWrapper.bottomAnchor),
            reconstructedImageView.trailingAnchor.constraint(equalTo: reconstructedWrapper.trailingAnchor),
            reconstructedImageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        let selectorWrapperWidthConstraint: CGFloat = 200
        let selectorWrapperLeadingConstraint = -1 * (selectorWrapperWidthConstraint / 2)
        let selectorWidthMultiplier = 2 / selectorWrapperWidthConstraint
        
        NSLayoutConstraint.activate([
            selectorWrapper.topAnchor.constraint(equalTo: reconstructedWrapper.topAnchor),
            selectorWrapper.bottomAnchor.constraint(equalTo: reconstructedWrapper.bottomAnchor),
            selectorWrapper.leadingAnchor.constraint(equalTo: reconstructedWrapper.leadingAnchor, constant: selectorWrapperLeadingConstraint),
            selectorWrapper.widthAnchor.constraint(equalToConstant: selectorWrapperWidthConstraint)
        ])
        
        NSLayoutConstraint.activate([
            selector.centerXAnchor.constraint(equalTo: selectorWrapper.centerXAnchor),
            selector.centerYAnchor.constraint(equalTo: selectorWrapper.centerYAnchor),
            selector.widthAnchor.constraint(equalTo: selectorWrapper.widthAnchor, multiplier: selectorWidthMultiplier),
            selector.heightAnchor.constraint(equalTo: selectorWrapper.heightAnchor)
        ])
    }
    
    fileprivate func setupImageViews() {
          backgroundImageView.contentMode = .scaleAspectFill
          reconstructedImageView.contentMode = .scaleAspectFill
    }
      
    fileprivate func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        selectorWrapper.isUserInteractionEnabled = true
        selectorWrapper.addGestureRecognizer(panGesture)
        addGestureRecognizer(tapGesture)
    }
      
    fileprivate func addViewsToSuperView() {
        reconstructedWrapper.addSubview(reconstructedImageView)
        addSubview(backgroundImageView)
        addSubview(reconstructedWrapper)
          
        selectorWrapper.addSubview(selector)
        addSubview(selectorWrapper)
    }
      
    fileprivate func setupSelector() {
        selector.backgroundColor = .white
    }
    
    
    @objc func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        switch sender.state {
        case .began, .changed:
            var newSeparatorConstraint =  reconstuctedStoredFrame.origin.x + translation.x
            newSeparatorConstraint = max(newSeparatorConstraint, 0)
            newSeparatorConstraint = min(frame.width, newSeparatorConstraint)
            imageSeparatorConstraint.constant = newSeparatorConstraint
            layoutIfNeeded()
        case .ended, .cancelled:
            reconstuctedStoredFrame = reconstructedWrapper.frame
        default: break
        }
    }
    
    @objc func tapGestureHandler(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let touchLocation = sender.location(in: sender.view)
            var newSeparatorConstraint = max(touchLocation.x, 0)
            newSeparatorConstraint = min(frame.width, newSeparatorConstraint)
            imageSeparatorConstraint.constant = newSeparatorConstraint
            layoutIfNeeded()
            reconstuctedStoredFrame = reconstructedWrapper.frame
        default:
            break
        }
    }
}
