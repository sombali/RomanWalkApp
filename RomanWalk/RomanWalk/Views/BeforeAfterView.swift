//
//  BeforeAfterView.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
public class ReconstructionView: UIView {
    
    fileprivate var imageSeparatorConstraint: NSLayoutConstraint!
    fileprivate var reconstuctedStoredFrame: CGRect!
    
    @IBInspectable
    public var reconstructedImage: UIImage = UIImage() {
        didSet {
            reconstructedImageView.image = reconstructedImage
        }
    }
    
    @IBInspectable
    public var backgroundImage: UIImage = UIImage() {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }
    
    @IBInspectable
    public var selectorColor: UIColor = UIColor.black {
        didSet {
            selector.backgroundColor = selectorColor
        }
    }

    fileprivate lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    fileprivate lazy var reconstructedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
//
    fileprivate lazy var reconstructedWrapper: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    fileprivate lazy var selectorWrapper: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    fileprivate lazy var selector: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    lazy fileprivate var setupLeadingAndOriginRect: Void = {
        self.imageSeparatorConstraint.constant = frame.width / 2
        self.layoutIfNeeded()
        self.reconstuctedStoredFrame = reconstructedWrapper.frame
        print("SETUP LEADING AND ORIGIN RECT")
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

        _ = setupLeadingAndOriginRect
    }
}

extension ReconstructionView {
    fileprivate func initialize() {

        reconstructedWrapper.addSubview(reconstructedImageView)
        addSubview(backgroundImageView)
        addSubview(reconstructedWrapper)
        
        selectorWrapper.addSubview(selector)
        addSubview(selectorWrapper)
        
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
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        selectorWrapper.isUserInteractionEnabled = true
        selectorWrapper.addGestureRecognizer(panGesture)
        addGestureRecognizer(tapGesture)
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
