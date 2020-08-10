//
//  TacoDialogView.swift
//  Demo
//
//  Created by Tim Moose on 8/12/16.
//  Copyright © 2016 SwiftKick Mobile. All rights reserved.
//

import UIKit
import SwiftMessages

class TitleWithTwoButtonMessageView: MessageView {

    @IBOutlet weak var twoButtonTitleLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    var firstButtonHandler: (() -> Void)?
    var secondButtonHandler: (() -> Void)?
    
    @IBAction func firstButtonSelected() {
        firstButtonHandler?()
    }

    @IBAction func secondButtonSelected() {
        secondButtonHandler?()
    }
}
