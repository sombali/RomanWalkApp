//
//  CoinCoordinator.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 24..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class CoinCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = CoinViewController.instantiate()
        vc.tabBarItem = UITabBarItem(title: "Érmék", image: UIImage(named: "coin"), tag: 3)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentQRCodeViewController(_ qrCodeImage: UIImage, _ qrCodeString: String) {
        let qrCodeVC = QRCodeInspectionViewController.instantiate()
        let qrCodeComponents = qrCodeString.components(separatedBy: ";")
        qrCodeVC.qrCodeImage = qrCodeImage

        qrCodeVC.percentage = qrCodeComponents.last
        if let vc = navigationController.viewControllers.last {
            vc.present(qrCodeVC, animated: true)
        }
    }
}
