//
//  ReconstructionViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class ReconstructionViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var reconstructionView: ReconstructionView!
    var location: Location?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        if let location = location {
            reconstructionView.backgroundImageView.loadReconstructionImage(with: location.reconstructionBackgroundImageName)
            reconstructionView.reconstructedImageView.loadReconstructionImage(with: location.reconstructionImageName)
        }
    }
}
