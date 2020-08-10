//
//  UITextViewFixed.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
