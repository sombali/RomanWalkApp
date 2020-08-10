//
//  UIImageView+Ext.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 17..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SwiftEventBus

extension UIImageView {
    func loadImage(for object: DownloadedImageData, with processor: ImageProcessor? = nil) {
        if object.fileName != nil {
            if let fileName = object.fileName {
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
                if let path = path {
                    let provider = LocalFileImageDataProvider(fileURL: path)
                    self.kf.indicatorType = .activity
                    DispatchQueue.main.async {
                        if let processor = processor {
                            self.kf.setImage(with: provider, options: [.cacheOriginalImage ,.processor(processor)])
                        } else {
                            self.kf.setImage(with: provider, options: [])
                        }
                    }
                }
            }
        } else {
            kf.indicatorType = .activity
            DispatchQueue.main.async {
                if let processor = processor {
                    self.kf.setImage(with: object.image, options: [.processor(processor)])
                } else {
                    self.kf.setImage(with: object.image)
                }
            }

        }
    }
    
    func loadReconstructionImage(with name: String?) {
        if let name = name {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name)
            if let path = path {
                let provider = LocalFileImageDataProvider(fileURL: path)
                self.kf.indicatorType = .activity
                DispatchQueue.main.async {
                    self.kf.setImage(with: provider)
                }
            }
        }
    }
}
