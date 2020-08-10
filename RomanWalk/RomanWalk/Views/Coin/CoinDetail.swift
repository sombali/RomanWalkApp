//
//  CoinDetail.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 27..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import SwiftMessages
import UIKit

class CoinDetailView: MessageView {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var coinCollected: UILabel!
    
    @IBOutlet weak var view: UIView!

    var backButton: (() -> Void)?
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        backButton?()
    }
}
