//
//  QRCodeInspectionViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 25..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class QRCodeInspectionViewController: UIViewController, Storyboarded {

    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    var qrCodeImage: UIImage? = nil
    var percentage: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        qrCodeImageView.image = qrCodeImage
        if let percentage = percentage {
            percentageLabel.text = "\(percentage) %"
        }
    }
    
}
