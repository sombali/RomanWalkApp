//
//  Storyboarded.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 19..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let nameWithAppName = NSStringFromClass(self)
        let className = nameWithAppName.components(separatedBy: ".")[1]
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        return storyboard.instantiateViewController(identifier: className) as! Self
    }
}
