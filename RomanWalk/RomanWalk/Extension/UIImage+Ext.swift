//
//  UIImage+Ext.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 05. 06..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(iconName: String) {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let iconPath = URL(fileURLWithPath: dirPath).appendingPathComponent(iconName)
            do {
                let imageData = try Data(contentsOf: iconPath)
                self.init(data: imageData)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

