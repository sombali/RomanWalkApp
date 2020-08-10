//
//  CoinOptionsView.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 25..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import SwiftMessages

class CoinOptionsView: MessageView {

    var redeem: (() -> Void)?
    var inspect: (() -> Void)?
    
    @IBAction func redeemSelected() {
        redeem?()
    }

    @IBAction func inspectSelected() {
        inspect?()
    }
}
